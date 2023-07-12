class GistFile
  include JSON::Serializable

  getter filename : String
  getter content : String
  getter raw_url : String

  def initialize(@filename : String, @content : String, @raw_url : String)
  end

  def href
    uri = URI.parse(raw_url)
    uri.host = GIST_HOST
    path_and_file_anchor = path_and_file_anchor(uri)
    uri.path = path_and_file_anchor.path
    uri.fragment = path_and_file_anchor.file_anchor
    uri.to_s
  end

  private def path_and_file_anchor(uri : URI)
    path_parts = uri.path.split("/")
    PathAndFileAnchor.new(
      path: [path_parts[1], path_parts[2]].join("/"),
      filename: path_parts[-1]
    )
  end

  class PathAndFileAnchor
    getter file_anchor : String
    getter path : String

    def initialize(@path : String, filename : String)
      @file_anchor = "file-" + filename.tr(" ", "-").tr(".", "-")
    end
  end
end

class MissingGistFile
  GIST_HOST_AND_SCHEME = "https://#{GIST_HOST}"

  def initialize(@id : String, @filename : String?)
  end

  def content
    <<-TEXT
      Gist file missing.
      Click on filename to go to gist.
    TEXT
  end

  def href
    GIST_HOST_AND_SCHEME + "/#{@id}"
  end

  def filename
    @filename || "Unknown filename"
  end

  def ==(other : MissingGistFile)
    other.filename == filename && other.href == href
  end
end

class RateLimitedGistFile
  GIST_HOST_AND_SCHEME = "https://#{GIST_HOST}"

  def initialize(@id : String, @filename : String?)
  end

  def content
    <<-TEXT
      Can't fetch gist.
      GitHub rate limit reached.
      Click on filename to go to gist.
    TEXT
  end

  def href
    GIST_HOST_AND_SCHEME + "/#{@id}"
  end

  def filename
    @filename || "Unknown filename"
  end

  def ==(other : RateLimitedGistFile)
    other.filename == filename && other.href == href
  end
end

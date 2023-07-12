class GistParams
  class MissingGistId < Exception
  end

  GIST_ID_REGEX = /[a-f\d]+$/i

  getter id : String
  getter filename : String?

  def self.extract_from_url(href : String)
    uri = URI.parse(href)
    maybe_id = Path.posix(uri.path).stem

    if maybe_id.matches?(GIST_ID_REGEX)
      id = maybe_id
      filename = uri.query_params["file"]?
      new(id: id, filename: filename)
    else
      raise MissingGistId.new(href)
    end
  end

  def initialize(@id : String, @filename : String?)
  end
end

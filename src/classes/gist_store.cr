alias GistFiles = Array(GistFile)
alias GistHash = Hash(String, GistFiles)

class GistStore
  property store : GistHash

  def initialize(@store : GistHash = {} of String => GistFiles)
  end

  def store_gist_file(id : String, file : GistFile)
    store[id] ||= [] of GistFile
    store[id] << file
  end

  def get_gist_files(id : String, filename : String?) : Array(GistFile) | Array(MissingGistFile)
    files = store[id]?
    missing_file = MissingGistFile.new(id: id, filename: filename)
    if files
      if filename
        find_gist_file(files, filename, missing_file)
      else
        files
      end
    else
      return [missing_file]
    end
  end

  private def find_gist_file(
    files : Array(GistFile),
    filename : String,
    missing_file : MissingGistFile
  ) : Array(GistFile) | Array(MissingGistFile)
    gist_file = files.find { |file| file.filename == filename }
    if gist_file
      [gist_file]
    else
      [missing_file]
    end
  end

  private def client_class
    GithubClient
  end
end

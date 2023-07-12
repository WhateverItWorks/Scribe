class RateLimitedGistStore
  def get_gist_files(id : String, filename : String?)
    [RateLimitedGistFile.new(id: id, filename: filename)]
  end
end

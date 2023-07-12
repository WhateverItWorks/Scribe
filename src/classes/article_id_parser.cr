class ArticleIdParser
  include Monads

  ID_REGEX = /[\/\-]([0-9a-f]+)\/?$/i

  def self.parse(request : HTTP::Request)
    new.parse(request)
  end

  def parse(request : HTTP::Request) : Maybe
    from_params = post_id_from_params(request.query_params)
    from_path = post_id_from_path(request.path)
    from_params.or(from_path)
  end

  private def post_id_from_path(request_path : String)
    return Nothing(String).new if request_path.starts_with?("/tag/")
    Try(Regex::MatchData)
      .new(->{ request_path.match(ID_REGEX) })
      .to_maybe
      .fmap(->(matches : Regex::MatchData) { matches[1] })
  end

  private def post_id_from_params(params : URI::Params)
    maybe_uri = Try(String)
      .new(->{ params["redirectUrl"] })
      .to_maybe
      .fmap(->(url : String) { URI.parse(url) })
      .bind(->(uri : URI) { post_id_from_path(uri.path) })
  end
end

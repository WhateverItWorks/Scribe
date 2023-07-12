class PageConverter
  def convert(post : PostResponse::Post) : Page
    title, content = title_and_content(post)
    author = post.creator
    created_at = Time.unix_ms(post.createdAt)
    gist_store = gist_store(content)
    Page.new(
      title: title,
      author: author,
      created_at: Time.unix_ms(post.createdAt),
      nodes: ParagraphConverter.new.convert(content, gist_store)
    )
  end

  def convert(post : Nil) : MissingPage
    MissingPage.new
  end

  def title_and_content(post : PostResponse::Post) : {String, Array(PostResponse::Paragraph)}
    title = post.title
    paragraphs = post.content.bodyModel.paragraphs
    non_content_paragraphs = paragraphs.reject { |para| para.text == title }
    {title, non_content_paragraphs}
  end

  private def gist_store(paragraphs) : GistStore | RateLimitedGistStore
    store = GistStore.new
    gist_urls = GistScanner.new(paragraphs).scan
    gist_responses = gist_urls.map do |url|
      params = GistParams.extract_from_url(url)
      response = GithubClient.get_gist_response(params.id)
      if response.is_a?(GithubClient::RateLimitedResponse)
        return RateLimitedGistStore.new
      end
      JSON.parse(response.data.body)["files"].as_h.values.map do |json_any|
        store.store_gist_file(params.id, GistFile.from_json(json_any.to_json))
      end
    end
    store
  end
end

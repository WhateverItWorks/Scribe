class GistScanner
  GIST_HOST_AND_SCHEME = "https://#{GIST_HOST}"

  getter paragraphs : Array(PostResponse::Paragraph)

  def initialize(@paragraphs : Array(PostResponse::Paragraph))
  end

  def scan
    maybe_urls = paragraphs.compact_map do |paragraph|
      Monads::Try(PostResponse::IFrame).new(->{ paragraph.iframe })
        .to_maybe
        .fmap(->(iframe : PostResponse::IFrame) { iframe.mediaResource })
        .fmap(->(media : PostResponse::MediaResource) { media.href })
        .value_or(nil)
    end
    maybe_urls
      .select { |url| url.starts_with?(GIST_HOST_AND_SCHEME) }
      .map { |url| url_without_params(url) }
      .uniq
  end

  def url_without_params(url)
    uri = URI.parse(url)
    uri.query = nil
    uri.to_s
  end
end

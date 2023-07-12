class EmbeddedConverter
  include Nodes

  GIST_HOST_AND_SCHEME = "https://#{GIST_HOST}"

  getter paragraph : PostResponse::Paragraph
  getter gist_store : GistStore | RateLimitedGistStore

  def self.convert(
    paragraph : PostResponse::Paragraph,
    gist_store : GistStore | RateLimitedGistStore
  ) : Embedded | Empty
    new(paragraph, gist_store).convert
  end

  def initialize(
    @paragraph : PostResponse::Paragraph,
    @gist_store : GistStore | RateLimitedGistStore
  )
  end

  def convert : Embedded | Empty
    Monads::Try(PostResponse::IFrame).new(->{ paragraph.iframe })
      .to_maybe
      .fmap(->(iframe : PostResponse::IFrame) { iframe.mediaResource })
      .fmap(->media_to_embedded(PostResponse::MediaResource))
      .value_or(Empty.new)
  end

  private def media_to_embedded(media : PostResponse::MediaResource) : Embedded
    if media.iframeSrc.blank?
      custom_embed(media)
    else
      EmbeddedContent.new(
        src: media.iframeSrc,
        originalWidth: media.iframeWidth,
        originalHeight: media.iframeHeight,
        caption: caption
      )
    end
  end

  private def caption : FigureCaption?
    if !paragraph.text.blank?
      children = [Text.new(paragraph.text || "")] of Child
      FigureCaption.new(children: children)
    end
  end

  private def custom_embed(media : PostResponse::MediaResource) : Embedded
    if media.href.starts_with?(GIST_HOST_AND_SCHEME)
      GithubGist.new(href: media.href, gist_store: gist_store)
    else
      EmbeddedLink.new(href: media.href)
    end
  end
end

class Post::IFrame < BaseComponent
  needs paragraph : PostResponse::Paragraph

  def render
    embed = paragraph.iframe
    if embed
      embed_data = MediumClient.media_data(embed.mediaResource.id)
      embed_value = embed_data.payload.value
      if embed_value.iframeSrc.blank?
        iframe src: embed_data.payload.value.href
      else
        iframe src: embed_data.payload.value.iframeSrc
      end
    end
  end
end

class ParagraphConverter
  include Nodes

  def convert(
    paragraphs : Array(PostResponse::Paragraph),
    gist_store : GistStore | RateLimitedGistStore
  ) : Array(Child)
    if paragraphs.first?.nil?
      return [Empty.new] of Child
    else
      case paragraphs.first.type
      when PostResponse::ParagraphType::BQ
        paragraph = paragraphs.shift
        children = MarkupConverter.convert(paragraph.text, paragraph.markups)
        node = BlockQuote.new(children: children)
      when PostResponse::ParagraphType::H2
        paragraph = paragraphs.shift
        children = MarkupConverter.convert(paragraph.text, paragraph.markups)
        node = Heading1.new(children: children, identifier: paragraph.name || "")
      when PostResponse::ParagraphType::H3
        paragraph = paragraphs.shift
        children = MarkupConverter.convert(paragraph.text, paragraph.markups)
        node = Heading2.new(children: children, identifier: paragraph.name || "")
      when PostResponse::ParagraphType::H4
        paragraph = paragraphs.shift
        children = MarkupConverter.convert(paragraph.text, paragraph.markups)
        node = Heading3.new(children: children, identifier: paragraph.name || "")
      when PostResponse::ParagraphType::IFRAME
        paragraph = paragraphs.shift
        node = EmbeddedConverter.convert(paragraph, gist_store)
      when PostResponse::ParagraphType::IMG
        paragraph = paragraphs.shift
        node = convert_img(paragraph)
      when PostResponse::ParagraphType::MIXTAPE_EMBED
        paragraph = paragraphs.shift
        children = MarkupConverter.convert(paragraph.text, paragraph.markups)
        node = MixtapeEmbed.new(children: children)
      when PostResponse::ParagraphType::OLI
        list_items = convert_oli(paragraphs)
        node = OrderedList.new(children: list_items)
      when PostResponse::ParagraphType::P
        paragraph = paragraphs.shift
        children = MarkupConverter.convert(paragraph.text, paragraph.markups)
        node = Paragraph.new(children: children)
      when PostResponse::ParagraphType::PQ
        paragraph = paragraphs.shift
        children = MarkupConverter.convert(paragraph.text, paragraph.markups)
        node = BlockQuote.new(children: children)
      when PostResponse::ParagraphType::PRE
        paragraph = paragraphs.shift
        children = MarkupConverter.convert(paragraph.text, paragraph.markups)
        node = Preformatted.new(children: children)
      when PostResponse::ParagraphType::SECTION_CAPTION
        # unused. just here to catch the type instead of implicitly going to the
        # else block
        paragraph = paragraphs.shift
        node = Empty.new
      when PostResponse::ParagraphType::ULI
        list_items = convert_uli(paragraphs)
        node = UnorderedList.new(children: list_items)
      else
        paragraphs.shift # so we don't recurse infinitely
        node = Empty.new
      end

      [node, convert(paragraphs, gist_store)].flatten.reject(&.empty?)
    end
  end

  private def convert_uli(paragraphs : Array(PostResponse::Paragraph)) : Array(Child)
    if paragraphs.first? && paragraphs.first.type.is_a?(PostResponse::ParagraphType::ULI)
      paragraph = paragraphs.shift
      children = MarkupConverter.convert(paragraph.text, paragraph.markups)
      [ListItem.new(children: children)] + convert_uli(paragraphs)
    else
      [] of Child
    end
  end

  private def convert_oli(paragraphs : Array(PostResponse::Paragraph)) : Array(Child)
    if paragraphs.first? && paragraphs.first.type.is_a?(PostResponse::ParagraphType::OLI)
      paragraph = paragraphs.shift
      children = MarkupConverter.convert(paragraph.text, paragraph.markups)
      [ListItem.new(children: children)] + convert_oli(paragraphs)
    else
      [] of Child
    end
  end

  private def convert_img(paragraph : PostResponse::Paragraph) : Child
    if metadata = paragraph.metadata
      caption_markup = MarkupConverter.convert(paragraph.text, paragraph.markups)
      Figure.new(children: [
        Image.new(
          src: metadata.id,
          originalWidth: metadata.originalWidth,
          originalHeight: metadata.originalHeight
        ),
        FigureCaption.new(children: caption_markup),
      ] of Child)
    else
      Empty.new
    end
  end
end

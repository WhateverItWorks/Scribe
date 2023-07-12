struct RangeWithMarkup
  getter range : Range(Int32, Int32)
  getter markups : Array(PostResponse::Markup)

  def initialize(@range : Range, @markups : Array(PostResponse::Markup))
  end
end

class MarkupConverter
  include Nodes

  getter markups : Array(PostResponse::Markup)
  getter text : Slice(UInt16)

  def self.convert(text : String?, markups : Array(PostResponse::Markup))
    new(text, markups).convert
  end

  def initialize(text : String?, @markups : Array(PostResponse::Markup))
    @text = (text || "").to_utf16
  end

  def convert : Array(Child)
    ranges.flat_map do |range_with_markups|
      text_to_wrap = String.from_utf16(text[range_with_markups.range])
      wrap_in_markups(text_to_wrap, range_with_markups.markups)
    end
  end

  private def ranges
    markup_boundaries = markups.flat_map { |markup| [markup.start, markup.end] }
    bookended_markup_boundaries = ([0] + markup_boundaries + [text.size]).uniq.sort
    bookended_markup_boundaries.each_cons(2).map do |boundaries|
      range = (boundaries[0]...boundaries[1])
      covered_markups = markups.select do |markup|
        range.covers?(markup.start) || range.covers?(markup.end - 1)
      end
      RangeWithMarkup.new(range, covered_markups)
    end.to_a
  end

  def wrap_in_markups(
    child : String | Child,
    markups : Array(PostResponse::Markup)
  ) : Array(Child)
    if child.is_a?(String)
      child = Text.new(child)
    end
    if markups.first?.nil?
      return [child] of Child
    end
    marked_up = markup_node_in_container(child, markups[0])
    wrap_in_markups(marked_up, markups[1..])
  end

  private def markup_node_in_container(child : Child, markup : PostResponse::Markup)
    case markup.type
    when PostResponse::MarkupType::A
      if href = markup.href
        Anchor.new(href: href, children: [child] of Child)
      elsif user_id = markup.userId
        UserAnchor.new(user_id: user_id, children: [child] of Child)
      else
        Empty.new
      end
    when PostResponse::MarkupType::CODE
      Code.new(children: [child] of Child)
    when PostResponse::MarkupType::EM
      Emphasis.new(children: [child] of Child)
    when PostResponse::MarkupType::STRONG
      Strong.new(children: [child] of Child)
    else
      Code.new(children: [child] of Child)
    end
  end
end

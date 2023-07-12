require "../spec_helper"

include Nodes

describe MarkupConverter do
  describe "#convert" do
    it "returns just text with no markups" do
      markups = [] of PostResponse::Markup

      result = MarkupConverter.convert(text: "Hello, world", markups: markups)

      result.should eq([Text.new(content: "Hello, world")])
    end

    it "returns text with multiple markups" do
      markups = Array(PostResponse::Markup).from_json <<-JSON
        [
          {
            "title": null,
            "type": "STRONG",
            "href": null,
            "start": 0,
            "end": 6,
            "rel": null,
            "anchorType": null
          },
          {
            "title": null,
            "type": "EM",
            "href": null,
            "start": 11,
            "end": 21,
            "rel": null,
            "anchorType": null
          }
        ]
      JSON

      result = MarkupConverter.convert(text: "strong and emphasized only", markups: markups)

      result.should eq([
        Strong.new(children: [Text.new(content: "strong")] of Child),
        Text.new(content: " and "),
        Emphasis.new(children: [Text.new(content: "emphasized")] of Child),
        Text.new(content: " only"),
      ])
    end

    it "returns text with a code markup" do
      markups = Array(PostResponse::Markup).from_json <<-JSON
        [
          {
            "title": null,
            "type": "CODE",
            "href": null,
            "start": 7,
            "end": 11,
            "rel": null,
            "anchorType": null
          }
        ]
      JSON

      result = MarkupConverter.convert(text: "inline code", markups: markups)

      result.should eq([
        Text.new(content: "inline "),
        Code.new(children: [Text.new(content: "code")] of Child),
      ])
    end

    it "renders an A-LINK markup" do
      markups = Array(PostResponse::Markup).from_json <<-JSON
        [
          {
            "title": "",
            "type": "A",
            "href": "https://example.com",
            "start": 7,
            "end": 11,
            "rel": "",
            "anchorType": "LINK"
          }
        ]
      JSON

      result = MarkupConverter.convert(text: "I am a Link", markups: markups)

      result.should eq([
        Text.new("I am a "),
        Anchor.new(children: [Text.new("Link")] of Child, href: "https://example.com"),
      ])
    end

    it "renders an A-USER markup" do
      markups = Array(PostResponse::Markup).from_json <<-JSON
        [
          {
            "title": null,
            "type": "A",
            "href": null,
            "userId": "abc123",
            "start": 3,
            "end": 10,
            "rel": null,
            "anchorType": "USER"
          }
        ]
      JSON

      result = MarkupConverter.convert(text: "Hi Dr Nick!", markups: markups)

      result.should eq([
        Text.new("Hi "),
        UserAnchor.new(children: [Text.new("Dr Nick")] of Child, user_id: "abc123"),
        Text.new("!"),
      ])
    end

    it "renders overlapping markups" do
      markups = Array(PostResponse::Markup).from_json <<-JSON
        [
          {
            "title": null,
            "type": "STRONG",
            "href": null,
            "userId": null,
            "start": 7,
            "end": 15,
            "rel": null,
            "anchorType": null
          },
          {
            "title": null,
            "type": "EM",
            "href": null,
            "userId": null,
            "start": 0,
            "end": 10,
            "rel": null,
            "anchorType": null
          }
        ]
      JSON

      result = MarkupConverter.convert(text: "Italic and bold", markups: markups)

      result.should eq([
        Emphasis.new(children: [Text.new("Italic ")] of Child),
        Emphasis.new(children: [
          Strong.new(children: [Text.new("and")] of Child),
        ] of Child),
        Strong.new(children: [Text.new(" bold")] of Child),
      ])
    end

    it "handles offsets from unicode text" do
      markup = PostResponse::Markup.new(
        type: PostResponse::MarkupType::STRONG,
        start: 5,
        end: 6
      )

      result = MarkupConverter.convert(text: "💸💸 <", markups: [markup])

      result.should eq([
        Text.new("💸💸 "),
        Strong.new(children: [Text.new("<")] of Child),
      ])
    end
  end

  describe "#wrap_in_markups" do
    it "returns text wrapped in multiple markups" do
      markups = Array(PostResponse::Markup).from_json <<-JSON
        [
          {
            "title": null,
            "type": "STRONG",
            "href": null,
            "start": 0,
            "end": 17,
            "rel": null,
            "anchorType": null
          },
          {
            "title": null,
            "type": "A",
            "href": null,
            "userId": "abc123",
            "start": 13,
            "end": 17,
            "rel": null,
            "anchorType": "USER"
          }
        ]
      JSON
      converter = MarkupConverter.new(text: "it's ya boi, jack", markups: markups)

      result = converter.wrap_in_markups("jack", markups)

      result.should eq([
        UserAnchor.new(children: [
          Strong.new([
            Text.new("jack"),
          ] of Child),
        ] of Child, user_id: "abc123"),
      ])
    end
  end
end

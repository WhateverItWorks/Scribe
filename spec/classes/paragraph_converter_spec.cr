require "../spec_helper"

include Nodes

describe ParagraphConverter do
  it "converts a simple structure with no markups" do
    gist_store = GistStore.new
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "name": "ab12",
          "text": "Title",
          "type": "H3",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    expected = [Heading3.new(children: [Text.new(content: "Title")] of Child, identifier: "ab12")]

    result = ParagraphConverter.new.convert(paragraphs, gist_store)

    result.should eq expected
  end

  it "converts a simple structure with a markup" do
    gist_store = GistStore.new
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "name": "ab12",
          "text": "inline code",
          "type": "P",
          "markups": [
            {
              "name": null,
              "title": null,
              "type": "CODE",
              "href": null,
              "start": 7,
              "end": 11,
              "rel": null,
              "anchorType": null
            }
          ],
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    expected = [
      Paragraph.new(children: [
        Text.new(content: "inline "),
        Code.new(children: [Text.new(content: "code")] of Child),
      ] of Child),
    ]

    result = ParagraphConverter.new.convert(paragraphs, gist_store)

    result.should eq expected
  end

  it "groups <ul> list items into one list" do
    gist_store = GistStore.new
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "name": "ab12",
          "text": "One",
          "type": "ULI",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab13",
          "text": "Two",
          "type": "ULI",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab14",
          "text": "Not a list item",
          "type": "P",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    expected = [
      UnorderedList.new(children: [
        ListItem.new(children: [Text.new(content: "One")] of Child),
        ListItem.new(children: [Text.new(content: "Two")] of Child),
      ] of Child),
      Paragraph.new(children: [Text.new(content: "Not a list item")] of Child),
    ]

    result = ParagraphConverter.new.convert(paragraphs, gist_store)

    result.should eq expected
  end

  it "groups <ol> list items into one list" do
    gist_store = GistStore.new
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "name": "ab12",
          "text": "One",
          "type": "OLI",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab13",
          "text": "Two",
          "type": "OLI",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab14",
          "text": "Not a list item",
          "type": "P",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    expected = [
      OrderedList.new(children: [
        ListItem.new(children: [Text.new(content: "One")] of Child),
        ListItem.new(children: [Text.new(content: "Two")] of Child),
      ] of Child),
      Paragraph.new(children: [Text.new(content: "Not a list item")] of Child),
    ]

    result = ParagraphConverter.new.convert(paragraphs, gist_store)

    result.should eq expected
  end

  it "converts an IMG to a Figure" do
    gist_store = GistStore.new
    paragraph = PostResponse::Paragraph.from_json <<-JSON
      {
        "name": "ab12",
        "text": "Image by someuser",
        "type": "IMG",
        "markups": [
          {
            "title": "",
            "type": "A",
            "href": "https://unsplash.com/@someuser",
            "userId": null,
            "start": 9,
            "end": 17,
            "rel": "photo-creator",
            "anchorType": "LINK"
          }
        ],
        "iframe": null,
        "layout": "INSET_CENTER",
        "metadata": {
          "id": "image.png",
          "originalWidth": 1000,
          "originalHeight": 600
        }
      }
    JSON
    expected = [
      Figure.new(children: [
        Image.new(src: "image.png", originalWidth: 1000, originalHeight: 600),
        FigureCaption.new(children: [
          Text.new("Image by "),
          Anchor.new(
            children: [Text.new("someuser")] of Child,
            href: "https://unsplash.com/@someuser"
          ),
        ] of Child),
      ] of Child),
    ]

    result = ParagraphConverter.new.convert([paragraph], gist_store)

    result.should eq expected
  end

  it "converts all the tags" do
    gist_store = GistStore.new
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "name": "ab12",
          "text": "text",
          "type": "H2",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab13",
          "text": "text",
          "type": "H3",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab14",
          "text": "text",
          "type": "H4",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab15",
          "text": "text",
          "type": "P",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab16",
          "text": "text",
          "type": "PRE",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab17",
          "text": "text",
          "type": "BQ",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab18",
          "text": "text",
          "type": "PQ",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab19",
          "text": "text",
          "type": "ULI",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab20",
          "text": "text",
          "type": "OLI",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab21",
          "text": "text",
          "type": "IMG",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": {
            "id": "1*miroimage.png",
            "originalWidth": 618,
            "originalHeight": 682
          }
        },
        {
          "name": "ab22",
          "text": "",
          "type": "IFRAME",
          "markups": [],
          "iframe": {
            "mediaResource": {
              "href": "https://example.com",
              "iframeSrc": "",
              "iframeWidth": 0,
              "iframeHeight": 0
            }
          },
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab23",
          "text": "Mixtape",
          "type": "MIXTAPE_EMBED",
          "href": null,
          "layout": null,
          "markups": [
            {
              "title": "https://example.com",
              "type": "A",
              "href": "https://example.com",
              "userId": null,
              "start": 0,
              "end": 7,
              "anchorType": "LINK"
            }
          ],
          "iframe": null,
          "metadata": null
        }
      ]
    JSON
    expected = [
      Heading1.new([Text.new("text")] of Child, identifier: "ab12"),
      Heading2.new([Text.new("text")] of Child, identifier: "ab13"),
      Heading3.new([Text.new("text")] of Child, identifier: "ab14"),
      Paragraph.new([Text.new("text")] of Child),
      Preformatted.new([Text.new("text")] of Child),
      BlockQuote.new([Text.new("text")] of Child), # BQ
      BlockQuote.new([Text.new("text")] of Child), # PQ
      UnorderedList.new([ListItem.new([Text.new("text")] of Child)] of Child),
      OrderedList.new([ListItem.new([Text.new("text")] of Child)] of Child),
      Figure.new(children: [
        Image.new(src: "1*miroimage.png", originalWidth: 618, originalHeight: 682),
        FigureCaption.new(children: [Text.new("text")] of Child),
      ] of Child),
      EmbeddedLink.new(href: "https://example.com"),
      MixtapeEmbed.new(children: [
        Anchor.new(
          children: [Text.new("Mixtape")] of Child,
          href: "https://example.com"
        ),
      ] of Child),
    ]

    result = ParagraphConverter.new.convert(paragraphs, gist_store)

    result.should eq expected
  end
end

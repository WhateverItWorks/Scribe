require "../spec_helper"

include Nodes

describe EmbeddedConverter do
  context "when the mediaResource has an iframeSrc value" do
    it "returns an EmbeddedContent node" do
      store = GistStore.new
      paragraph = PostResponse::Paragraph.from_json <<-JSON
        {
          "name": "ab12",
          "text": "",
          "type": "IFRAME",
          "href": null,
          "layout": "INSET_CENTER",
          "markups": [],
          "iframe": {
            "mediaResource": {
              "id": "abc123",
              "href": "https://twitter.com/user/status/1",
              "iframeSrc": "https://cdn.embedly.com/widgets/...",
              "iframeWidth": 500,
              "iframeHeight": 281
            }
          },
          "metadata": null
        }
      JSON

      result = EmbeddedConverter.convert(paragraph, store)

      result.should eq(
        EmbeddedContent.new(
          src: "https://cdn.embedly.com/widgets/...",
          originalWidth: 500,
          originalHeight: 281,
        )
      )
    end

    context "and a caption exists" do
      it "returns an EmbeddedContent node with caption" do
        store = GistStore.new
        paragraph = PostResponse::Paragraph.from_json <<-JSON
          {
            "name": "ab12",
            "text": "Caption",
            "type": "IFRAME",
            "href": null,
            "layout": "INSET_CENTER",
            "markups": [],
            "iframe": {
              "mediaResource": {
                "id": "abc123",
                "href": "https://twitter.com/user/status/1",
                "iframeSrc": "https://cdn.embedly.com/widgets/...",
                "iframeWidth": 500,
                "iframeHeight": 281
              }
            },
            "metadata": null
          }
        JSON
        caption = FigureCaption.new(children: [Text.new("Caption")] of Child)

        result = EmbeddedConverter.convert(paragraph, store)

        result.should eq(
          EmbeddedContent.new(
            src: "https://cdn.embedly.com/widgets/...",
            originalWidth: 500,
            originalHeight: 281,
            caption: caption,
          )
        )
      end
    end
  end

  context "when the mediaResource has a blank iframeSrc value" do
    context "and the href is unknown" do
      it "returns an EmbeddedLink node" do
        store = GistStore.new
        paragraph = PostResponse::Paragraph.from_json <<-JSON
          {
            "name": "ab12",
            "text": "",
            "type": "IFRAME",
            "href": null,
            "layout": "INSET_CENTER",
            "markups": [],
            "iframe": {
              "mediaResource": {
                "id": "abc123",
                "href": "https://example.com",
                "iframeSrc": "",
                "iframeWidth": 0,
                "iframeHeight": 0
              }
            },
            "metadata": null
          }
        JSON

        result = EmbeddedConverter.convert(paragraph, store)

        result.should eq(EmbeddedLink.new(href: "https://example.com"))
      end
    end

    context "and the href is gist.github.com" do
      it "returns an GithubGist node" do
        store = GistStore.new
        paragraph = PostResponse::Paragraph.from_json <<-JSON
          {
            "name": "ab12",
            "text": "",
            "type": "IFRAME",
            "href": null,
            "layout": "INSET_CENTER",
            "markups": [],
            "iframe": {
              "mediaResource": {
                "id": "abc123",
                "href": "https://gist.github.com/user/someid",
                "iframeSrc": "",
                "iframeWidth": 0,
                "iframeHeight": 0
              }
            },
            "metadata": null
          }
        JSON

        result = EmbeddedConverter.convert(paragraph, store)

        result.should eq(
          GithubGist.new(
            href: "https://gist.github.com/user/someid",
            gist_store: store
          )
        )
      end
    end
  end
end

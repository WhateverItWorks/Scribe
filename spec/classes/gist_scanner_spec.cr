require "../spec_helper"

describe GistScanner do
  it "returns gist ids from paragraphs" do
    iframe = PostResponse::IFrame.new(
      PostResponse::MediaResource.new(
        href: "https://gist.github.com/user/123ABC",
        iframeSrc: "",
        iframeWidth: 0,
        iframeHeight: 0
      )
    )
    paragraphs = [
      PostResponse::Paragraph.new(
        name: "ab12",
        text: "Check out this gist:",
        type: PostResponse::ParagraphType::P,
        markups: [] of PostResponse::Markup,
        iframe: nil,
        layout: nil,
        metadata: nil
      ),
      PostResponse::Paragraph.new(
        name: "ab13",
        text: "",
        type: PostResponse::ParagraphType::IFRAME,
        markups: [] of PostResponse::Markup,
        iframe: iframe,
        layout: nil,
        metadata: nil
      ),
    ]

    result = GistScanner.new(paragraphs).scan

    result.should eq(["https://gist.github.com/user/123ABC"])
  end

  it "returns ids without the file parameters" do
    iframe = PostResponse::IFrame.new(
      PostResponse::MediaResource.new(
        href: "https://gist.github.com/user/123ABC?file=example.txt",
        iframeSrc: "",
        iframeWidth: 0,
        iframeHeight: 0
      )
    )
    paragraphs = [
      PostResponse::Paragraph.new(
        name: "ab12",
        text: "",
        type: PostResponse::ParagraphType::IFRAME,
        markups: [] of PostResponse::Markup,
        iframe: iframe,
        layout: nil,
        metadata: nil
      ),
    ]

    result = GistScanner.new(paragraphs).scan

    result.should eq(["https://gist.github.com/user/123ABC"])
  end

  it "returns a unique list of ids" do
    iframe1 = PostResponse::IFrame.new(
      PostResponse::MediaResource.new(
        href: "https://gist.github.com/user/123ABC?file=example.txt",
        iframeSrc: "",
        iframeWidth: 0,
        iframeHeight: 0
      )
    )
    iframe2 = PostResponse::IFrame.new(
      PostResponse::MediaResource.new(
        href: "https://gist.github.com/user/123ABC?file=other.txt",
        iframeSrc: "",
        iframeWidth: 0,
        iframeHeight: 0
      )
    )
    paragraphs = [
      PostResponse::Paragraph.new(
        name: "ab12",
        text: "",
        type: PostResponse::ParagraphType::IFRAME,
        markups: [] of PostResponse::Markup,
        iframe: iframe1,
        layout: nil,
        metadata: nil
      ),
      PostResponse::Paragraph.new(
        name: "ab13",
        text: "",
        type: PostResponse::ParagraphType::IFRAME,
        markups: [] of PostResponse::Markup,
        iframe: iframe2,
        layout: nil,
        metadata: nil
      ),
    ]

    result = GistScanner.new(paragraphs).scan

    result.should eq(["https://gist.github.com/user/123ABC"])
  end
end

require "../spec_helper"

module Nodes
  describe EmbeddedLink do
    it "returns embedded url with subdomains" do
      iframe = EmbeddedLink.new(href: "https://dev.example.com/page")

      iframe.domain.should eq("dev.example.com")
    end
  end

  describe Image do
    it "adjusts the width and height proportionally" do
      image = Image.new(src: "image.png", originalWidth: 1000, originalHeight: 603)

      image.width.should eq("800")
      image.height.should eq("482")
    end

    it "includes the adjusted width and height in the src" do
      image = Image.new(src: "image.png", originalWidth: 1000, originalHeight: 603)

      image.src.should eq("https://cdn-images-1.medium.com/fit/c/800/482/image.png")
    end
  end

  describe EmbeddedContent do
    it "adjusts the width and height proportionally" do
      content = EmbeddedContent.new(
        src: "https://example.com",
        originalWidth: 1000,
        originalHeight: 600,
      )

      content.width.should eq("800")
      content.height.should eq("480")
    end
  end
end

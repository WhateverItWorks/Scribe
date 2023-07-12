require "../spec_helper"

describe GistParams do
  it "extracts params from the gist url" do
    url = "https://gist.github.com/user/1D?file=example.txt"

    params = GistParams.extract_from_url(url)

    params.id.should eq("1D")
    params.filename.should eq("example.txt")
  end

  describe "when gist file has a file extension" do
    it "extracts params from the gist url" do
      url = "https://gist.github.com/user/1d.js"

      params = GistParams.extract_from_url(url)

      params.id.should eq("1d")
    end
  end

  describe "when no file param exists" do
    it "does not extract a filename" do
      url = "https://gist.github.com/user/1D"

      params = GistParams.extract_from_url(url)

      params.id.should eq("1D")
      params.filename.should be_nil
    end
  end

  describe "when the URL is not a gist URL" do
    it "raises a MissingGistId exeption" do
      url = "https://example.com"

      expect_raises(GistParams::MissingGistId, message: "https://example.com") do
        GistParams.extract_from_url(url)
      end
    end
  end
end

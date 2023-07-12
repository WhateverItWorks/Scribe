require "../spec_helper"

describe RateLimitedGistStore do
  describe "when a filename is given" do
    it "returns a RateLimitedGistFile for that filename" do
      store = RateLimitedGistStore.new

      gists = store.get_gist_files(id: "1", filename: "one")

      gists.should eq([RateLimitedGistFile.new(id: "1", filename: "one")])
    end
  end

  describe "when a filename is NOT given" do
    it "returns a single RateLimitedGistFile" do
      store = RateLimitedGistStore.new

      gists = store.get_gist_files(id: "1", filename: nil)

      gists.should eq([RateLimitedGistFile.new(id: "1", filename: nil)])
    end
  end
end

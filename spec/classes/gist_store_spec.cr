require "../spec_helper"

describe GistStore do
  describe "#store_gist_file" do
    describe "adds the gist file to the gist id" do
      it "calls the github client" do
        store = GistStore.new
        file = GistFile.new(
          filename: "filename",
          content: "content",
          raw_url: "raw_url"
        )

        store.store_gist_file("1", file)

        store.store["1"].should eq([file])
      end
    end
  end

  describe "the gist does not exist in the store" do
    it "returns a MissingGistFile" do
      missing_file = MissingGistFile.new(id: "1", filename: "filename")
      store = GistStore.new

      file = store.get_gist_files(id: "1", filename: "filename")

      file.should eq([missing_file])
    end
  end

  describe "when a filename is given" do
    it "returns the GistFile for that filename" do
      store = GistStore.new
      file1 = GistFile.new("one", "", "")
      file2 = GistFile.new("two", "", "")
      store.store["1"] = [file1, file2]

      gists = store.get_gist_files(id: "1", filename: "one")

      gists.should eq([file1])
      gists.should_not contain([file2])
    end
  end

  describe "when a filename is NOT given" do
    it "returns all GistFiles" do
      store = GistStore.new
      file1 = GistFile.new("one", "", "")
      file2 = GistFile.new("two", "", "")
      store.store["1"] = [file1, file2]

      gists = store.get_gist_files(id: "1", filename: nil)

      gists.should eq([file1, file2])
    end
  end
end

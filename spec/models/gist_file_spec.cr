require "../spec_helper"

describe GistFile do
  it "is parsed from json" do
    json = <<-JSON
      {
        "filename": "example.txt",
        "raw_url": "https://gist.githubusercontent.com/user/1D/raw/FFF/example.txt",
        "content": "content"
      }
    JSON

    gist_file = GistFile.from_json(json)

    gist_file.filename.should eq("example.txt")
    gist_file.content.should eq("content")
    gist_file.raw_url.should eq("https://gist.githubusercontent.com/user/1D/raw/FFF/example.txt")
  end

  it "returns an href for the gist's webpage" do
    json = <<-JSON
      {
        "filename": "example.txt",
        "raw_url": "https://gist.githubusercontent.com/user/1D/raw/FFF/example.txt",
        "content": "content"
      }
    JSON
    gist_file = GistFile.from_json(json)

    href = gist_file.href

    href.should eq("https://gist.github.com/user/1D#file-example-txt")
  end
end

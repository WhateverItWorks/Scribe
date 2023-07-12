require "../spec_helper"

include Nodes

describe PageConverter do
  it "sets the page title" do
    title = "Hello, world!"
    paragraph_json = <<-JSON
      [
        {
          "name": "ab12",
          "text": "#{title}",
          "type": "H3",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    data_json = default_post_json(title, paragraph_json)
    data = PostResponse::Post.from_json(data_json)

    page = PageConverter.new.convert(data)

    page.title.should eq title
  end

  it "sets the author" do
    post_json = <<-JSON
      {
        "name": "ab12",
        "title": "This is a story",
        "createdAt": 0,
        "creator": {
          "id": "abc123",
          "name": "Author"
        },
        "content": {
          "bodyModel": {
            "paragraphs": []
          }
        }
      }
    JSON
    post = PostResponse::Post.from_json(post_json)

    page = PageConverter.new.convert(post)

    page.author.name.should eq "Author"
    page.author.id.should eq "abc123"
  end

  it "sets the publish date/time" do
    post_json = <<-JSON
      {
        "name": "ab12",
        "title": "This is a story",
        "createdAt": 1000,
        "creator": {
          "id": "abc123",
          "name": "Author"
        },
        "content": {
          "bodyModel": {
            "paragraphs": []
          }
        }
      }
    JSON
    post = PostResponse::Post.from_json(post_json)

    page = PageConverter.new.convert(post)

    page.created_at.should eq Time.utc(1970, 1, 1, 0, 0, 1)
  end

  it "calls converts the remaining paragraph content" do
    title = "Title"
    paragraph_json = <<-JSON
      [
        {
          "name": "ab12",
          "text": "#{title}",
          "type": "H3",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "name": "ab12",
          "text": "Content",
          "type": "P",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    post_json = default_post_json(title, paragraph_json)
    data = PostResponse::Post.from_json(post_json)

    page = PageConverter.new.convert(data)

    page.nodes.should eq [
      Paragraph.new([
        Text.new("Content"),
      ] of Child),
    ]
  end
end

def default_paragraph_json
  "[]"
end

def default_post_json(
  title : String = "This is a story",
  paragraph_json : String = default_paragraph_json
)
  <<-JSON
    {
      "name": "ab12",
      "title": "#{title}",
      "createdAt": 1628974309758,
      "creator": {
        "id": "abc123",
        "name": "Author"
      },
      "content": {
        "bodyModel": {
          "paragraphs": #{paragraph_json}
        }
      }
    }
  JSON
end

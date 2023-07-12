require "../spec_helper"

include Nodes

describe PageContent do
  it "renders a single parent/child node structure" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Paragraph.new(children: [
          Text.new(content: "hi"),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<p>hi</p>)
  end

  it "renders multiple childrens" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Paragraph.new(children: [
          Text.new(content: "Hello, "),
          Emphasis.new(children: [
            Text.new(content: "World!"),
          ] of Child),
        ] of Child),
        UnorderedList.new(children: [
          ListItem.new(children: [
            Text.new(content: "List!"),
          ] of Child),
          ListItem.new(children: [
            Text.new(content: "Again!"),
          ] of Child),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<p>Hello, <em>World!</em></p><ul><li>List!</li><li>Again!</li></ul>)
  end

  it "renders an anchor" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Anchor.new(children: [Text.new("link")] of Child, href: "https://example.com"),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<a href="https://example.com">link</a>)
  end

  it "renders a blockquote" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        BlockQuote.new(children: [
          Text.new("Wayne Gretzky. Michael Scott."),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<blockquote><p>Wayne Gretzky. Michael Scott.</p></blockquote>)
  end

  it "renders code" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Code.new(children: [
          Text.new("foo = bar"),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<code>foo = bar</code>)
  end

  it "renders empasis" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Paragraph.new(children: [
          Text.new(content: "This is "),
          Emphasis.new(children: [
            Text.new(content: "neat!"),
          ] of Child),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<p>This is <em>neat!</em></p>)
  end

  it "renders a figure and figure caption" do
    children = [Text.new("A caption")] of Child
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Figure.new(children: [
          Image.new(src: "image.png", originalWidth: 100, originalHeight: 200),
          FigureCaption.new(children: children),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq stripped_html <<-HTML
      <figure>
        <img src="https://cdn-images-1.medium.com/fit/c/100/200/image.png" width="100">
        <label class="margin-toggle" for="#{children.hash}">&#9997;&#xFE0E;</label>
        <input class="margin-toggle" type="checkbox" id="#{children.hash}">
        <span class="marginnote">
          A caption
        </span>
      </figure>
    HTML
  end

  it "renders a GitHub Gist" do
    store = GistStore.new
    gist_file = GistFile.new(
      filename: "example",
      content: "content",
      raw_url: "https://gist.githubusercontent.com/user/1/raw/abc/example"
    )
    store.store["1"] = [gist_file]
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        GithubGist.new(href: "https://gist.github.com/user/1", gist_store: store),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq stripped_html <<-HTML
      <p>
        <code>
          <a href="https://gist.github.com/user/1#file-example">example</a>
        </code>
      </p>
      <pre class="gist">
        <code>content</code>
      </pre>
    HTML
  end

  it "renders an H2" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Heading1.new(children: [
          Text.new(content: "Title!"),
        ] of Child, identifier: "ab12"),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<h1 id="ab12">Title!</h1>)
  end

  it "renders an H3" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Heading2.new(children: [
          Text.new(content: "Title!"),
        ] of Child, identifier: "ab12"),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<h2 id="ab12">Title!</h2>)
  end

  it "renders an H4" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Heading3.new(children: [
          Text.new(content: "In Conclusion..."),
        ] of Child, identifier: "ab12"),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<h3 id="ab12">In Conclusion...</h3>)
  end

  it "renders an image" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Paragraph.new(children: [
          Image.new(src: "image.png", originalWidth: 100, originalHeight: 200),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq stripped_html <<-HTML
      <p>
        <img src="https://cdn-images-1.medium.com/fit/c/100/200/image.png" width="100">
      </p>
    HTML
  end

  it "renders embedded content" do
    caption_children = [Text.new("Caption")] of Child
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        EmbeddedContent.new(
          src: "https://example.com",
          originalWidth: 1000,
          originalHeight: 600,
          caption: FigureCaption.new(children: caption_children)
        ),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq stripped_html <<-HTML
      <figure>
        <iframe src="https://example.com" width="800" height="480" frameborder="0" allowfullscreen="true">
        </iframe>
        <label class="margin-toggle" for="#{caption_children.hash}">&#9997;&#xFE0E;</label>
        <input class="margin-toggle" type="checkbox" id="#{caption_children.hash}">
        <span class="marginnote">
          Caption
        </span>
      </figure>
    HTML
  end

  it "renders an embedded link container" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Paragraph.new(children: [
          EmbeddedLink.new(href: "https://example.com"),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq stripped_html <<-HTML
      <p>
        <figure>
          <a href="https://example.com">Embedded content at example.com</a>
        </figure>
      </p>
    HTML
  end

  it "renders an mixtape embed container" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Paragraph.new(children: [
          MixtapeEmbed.new(children: [
            Anchor.new(
              children: [Text.new("Mixtape")] of Child,
              href: "https://example.com"
            ),
          ] of Child),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq stripped_html <<-HTML
      <p>
        <blockquote>
          <p>
            <a href="https://example.com">Mixtape</a>
          </p>
        </blockquote>
      </p>
    HTML
  end

  it "renders an ordered list" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        OrderedList.new(children: [
          ListItem.new(children: [Text.new("One")] of Child),
          ListItem.new(children: [Text.new("Two")] of Child),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<ol><li>One</li><li>Two</li></ol>)
  end

  it "renders an preformatted text" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Paragraph.new(children: [
          Text.new("Hello, world!"),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<p>Hello, world!</p>)
  end

  it "renders an preformatted text" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Preformatted.new(children: [
          Text.new("New\nline"),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<pre>New\nline</pre>)
  end

  it "renders strong text" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        Strong.new(children: [
          Text.new("Oh yeah!"),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<strong>Oh yeah!</strong>)
  end

  it "renders an unordered list" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        UnorderedList.new(children: [
          ListItem.new(children: [Text.new("Apple")] of Child),
          ListItem.new(children: [Text.new("Banana")] of Child),
        ] of Child),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<ul><li>Apple</li><li>Banana</li></ul>)
  end

  it "renders a user anchor" do
    page = Page.new(
      title: "Title",
      author: user_anchor_factory,
      created_at: Time.local,
      nodes: [
        UserAnchor.new(children: [Text.new("Some User")] of Child, user_id: "abc123"),
      ] of Child
    )

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<a href="https://medium.com/u/abc123">Some User</a>)
  end
end

def stripped_html(html : String)
  html.gsub(/\n\s*/, "").strip
end

def user_anchor_factory(username = "someone", user_id = "abc123")
  PostResponse::Creator.from_json <<-JSON
    {
      "id": "#{user_id}",
      "name": "#{username}"
    }
  JSON
end

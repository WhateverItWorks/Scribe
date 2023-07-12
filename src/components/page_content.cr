class PageContent < BaseComponent
  include Nodes
  needs page : Page

  def render
    page.nodes.each do |node|
      render_child(node)
    end
  end

  def render_children(children : Children)
    children.each { |child| render_child(child) }
  end

  def render_child(node : Anchor)
    a(href: node.href) { render_children(node.children) }
  end

  def render_child(node : BlockQuote)
    blockquote do
      para { render_children(node.children) }
    end
  end

  def render_child(node : Code)
    code { render_children(node.children) }
  end

  def render_child(container : Container)
    # Should never get called
    raw "<!-- a Container was rendered -->"
  end

  def render_child(child : EmbeddedContent)
    figure do
      iframe(
        src: child.src,
        width: child.width,
        height: child.height,
        frameborder: "0",
        allowfullscreen: true,
      )
      if caption = child.caption
        render_child(caption)
      end
    end
  end

  def render_child(child : EmbeddedLink)
    figure do
      a href: child.href do
        text "Embedded content at #{child.domain}"
      end
    end
  end

  def render_child(node : Emphasis)
    em { render_children(node.children) }
  end

  def render_child(container : Empty)
    # Should never get called
    raw "<!-- an Empty was rendered -->"
  end

  def render_child(node : Figure)
    figure { render_children(node.children) }
  end

  def render_child(node : FigureCaption)
    writing_hand = "&#9997;"
    text_variant = "&#xFE0E;"
    footnote_id = node.children.hash.to_s
    label class: "margin-toggle", for: footnote_id do
      raw writing_hand + text_variant
    end
    input class: "margin-toggle", type: "checkbox", id: footnote_id
    span class: "marginnote" do
      render_children(node.children)
    end
  end

  def render_child(gist : GithubGist)
    gist.files.map { |gist_file| render_child(gist_file) }
  end

  def render_child(gist_file : GistFile | MissingGistFile | RateLimitedGistFile)
    para do
      code do
        a gist_file.filename, href: gist_file.href
      end
    end
    pre class: "gist" do
      code gist_file.content
    end
  end

  def render_child(node : Heading1)
    h1(id: node.identifier) { render_children(node.children) }
  end

  def render_child(node : Heading2)
    h2(id: node.identifier) { render_children(node.children) }
  end

  def render_child(node : Heading3)
    h3(id: node.identifier) { render_children(node.children) }
  end

  def render_child(child : Image)
    img src: child.src, width: child.width
  end

  def render_child(node : ListItem)
    li { render_children(node.children) }
  end

  def render_child(node : MixtapeEmbed)
    blockquote do
      para { render_children(node.children) }
    end
  end

  def render_child(node : OrderedList)
    ol { render_children(node.children) }
  end

  def render_child(node : Paragraph)
    para { render_children(node.children) }
  end

  def render_child(node : Preformatted)
    pre { render_children(node.children) }
  end

  def render_child(node : Strong)
    strong { render_children(node.children) }
  end

  def render_child(child : Text)
    text child.content
  end

  def render_child(node : UnorderedList)
    ul { render_children(node.children) }
  end

  def render_child(node : UserAnchor)
    a(href: node.href) { render_children(node.children) }
  end
end

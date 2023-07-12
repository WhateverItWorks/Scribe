module Nodes
  alias Embedded = EmbeddedLink | EmbeddedContent | GithubGist
  alias Leaf = Text | Image | Embedded
  alias Child = Container | Leaf | Empty
  alias Children = Array(Child)

  class Container
    getter children : Children

    def initialize(@children : Children)
    end

    def ==(other : Container)
      other.children == children
    end

    def empty?
      children.empty? || children.each(&.empty?)
    end
  end

  class Empty
    def empty?
      true
    end
  end

  class BlockQuote < Container
  end

  class Code < Container
  end

  class Emphasis < Container
  end

  class Figure < Container
  end

  class FigureCaption < Container
  end

  class Heading1 < Container
    getter identifier : String

    def initialize(@children : Children, @identifier : String)
    end
  end

  class Heading2 < Container
    getter identifier : String

    def initialize(@children : Children, @identifier : String)
    end
  end

  class Heading3 < Container
    getter identifier : String

    def initialize(@children : Children, @identifier : String)
    end
  end

  class ListItem < Container
  end

  class MixtapeEmbed < Container
  end

  class OrderedList < Container
  end

  class Paragraph < Container
  end

  class Preformatted < Container
  end

  class Strong < Container
  end

  class UnorderedList < Container
  end

  class Text
    getter content : String

    def initialize(@content : String)
    end

    def ==(other : Text)
      other.content == content
    end

    def empty?
      content.empty?
    end
  end

  class Image
    IMAGE_HOST      = "https://cdn-images-1.medium.com/fit/c"
    MAX_WIDTH       = 800
    FALLBACK_HEIGHT = 600

    getter originalHeight : Int32
    getter originalWidth : Int32

    def initialize(
      @src : String,
      originalWidth : Int32?,
      originalHeight : Int32?
    )
      @originalWidth = originalWidth || MAX_WIDTH
      @originalHeight = originalHeight || FALLBACK_HEIGHT
    end

    def ==(other : Image)
      other.src == src
    end

    def src
      [IMAGE_HOST, width, height, @src].join("/")
    end

    def width
      [originalWidth, MAX_WIDTH].min.to_s
    end

    def height
      if originalWidth > MAX_WIDTH
        (originalHeight * ratio).round.to_i.to_s
      else
        originalHeight.to_s
      end
    end

    private def ratio
      MAX_WIDTH / originalWidth
    end

    def empty?
      false
    end
  end

  class EmbeddedContent
    MAX_WIDTH = 800

    getter src : String
    getter caption : FigureCaption?

    def initialize(
      @src : String,
      @originalWidth : Int32,
      @originalHeight : Int32,
      @caption : FigureCaption? = nil
    )
    end

    def width
      [@originalWidth, MAX_WIDTH].min.to_s
    end

    def height
      if @originalWidth > MAX_WIDTH
        (@originalHeight * ratio).round.to_i.to_s
      else
        @originalHeight.to_s
      end
    end

    private def ratio
      MAX_WIDTH / @originalWidth
    end

    def ==(other : EmbeddedContent)
      other.src == src &&
        other.width == width &&
        other.height == height &&
        other.caption == caption
    end

    def empty?
      false
    end
  end

  class EmbeddedLink
    getter href : String

    def initialize(@href : String)
    end

    def domain
      URI.parse(href).host
    end

    def ==(other : EmbeddedLink)
      other.href == href
    end

    def empty?
      false
    end
  end

  class Anchor < Container
    getter href : String

    def initialize(@children : Children, @href : String)
    end

    def ==(other : Anchor)
      other.children == children && other.href == href
    end

    def empty?
      false
    end
  end

  class UserAnchor < Container
    USER_BASE_URL = "https://medium.com/u/"

    getter href : String

    def initialize(@children : Children, user_id : String)
      @href = USER_BASE_URL + user_id
    end

    def ==(other : UserAnchor)
      other.children == children && other.href == href
    end

    def empty?
      false
    end
  end

  class GithubGist
    getter gist_store : GistStore | RateLimitedGistStore

    def initialize(@href : String, @gist_store : GistStore | RateLimitedGistStore)
    end

    def files : Array(GistFile) | Array(MissingGistFile) | Array(RateLimitedGistFile)
      gist_store.get_gist_files(params.id, params.filename)
    end

    private def params
      GistParams.extract_from_url(@href)
    end

    def ==(other : GithubGist)
      other.gist_store == gist_store
    end

    def empty?
      false
    end
  end
end

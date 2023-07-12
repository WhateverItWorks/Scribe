class PostResponse
  class Base
    include JSON::Serializable
  end

  class Root < Base
    property data : Data
  end

  class Data < Base
    property post : Post?
  end

  class Post < Base
    property title : String
    property createdAt : Int64
    property creator : Creator
    property content : Content
  end

  class Creator < Base
    property name : String
    property id : String
  end

  class Content < Base
    property bodyModel : BodyModel
  end

  class BodyModel < Base
    property paragraphs : Array(Paragraph)
  end

  class Paragraph < Base
    property name : String?
    property text : String?
    property type : ParagraphType
    property markups : Array(Markup)
    property iframe : IFrame?
    property layout : String?
    property metadata : Metadata?

    def initialize(
      @name : String,
      @text : String?,
      @type : ParagraphType,
      @markups : Array(Markup),
      @iframe : IFrame?,
      @layout : String?,
      @metadata : Metadata?
    )
    end
  end

  enum ParagraphType
    BQ
    H2
    H3
    H4
    IFRAME
    IMG
    MIXTAPE_EMBED
    OLI
    P
    PQ
    PRE
    SECTION_CAPTION
    ULI
  end

  class Markup < Base
    property title : String?
    property type : MarkupType
    property href : String?
    property userId : String?
    property start : Int32
    property end : Int32
    property anchorType : AnchorType?

    def initialize(
      @type : MarkupType,
      @start : Int32,
      @end : Int32,
      @title : String? = nil,
      @href : String? = nil,
      @userId : String? = nil,
      @anchorType : AnchorType? = nil
    )
    end
  end

  enum MarkupType
    A
    CODE
    EM
    STRONG
  end

  enum AnchorType
    LINK
    USER
  end

  class IFrame < Base
    property mediaResource : MediaResource

    def initialize(@mediaResource : MediaResource)
    end
  end

  class MediaResource < Base
    property href : String
    property iframeSrc : String
    property iframeWidth : Int32
    property iframeHeight : Int32

    def initialize(
      @href : String,
      @iframeSrc : String,
      @iframeWidth : Int32,
      @iframeHeight : Int32
    )
    end
  end

  class Metadata < Base
    property id : String
    property originalWidth : Int32?
    property originalHeight : Int32?
  end
end

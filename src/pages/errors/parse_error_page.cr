class Errors::ParseErrorPage < MainLayout
  needs message : String
  needs status_code : Int32
  needs original_resource : String

  def page_title
    "Error"
  end

  def content
    h1 status_code
    h2 message
    article do
      what_can_scribe_show
      mount Shared::LayoutFooter
    end
  end

  private def what_can_scribe_show
    section do
      para <<-TEXT
        Scribe just tried to parse the Medium URL but wasn't able to. Scribe is
        only built to display articles. It's not built to browse or search
        Medium, it's users, hashtags, comments, or anything else.
      TEXT
      para do
        text "If you like, you can try visiting "
        a "this page on medium.com", href: "https://medium.com#{original_resource}"
      end
    end
  end
end

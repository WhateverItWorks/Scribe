abstract class MainLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def page_title

  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body do
        mount Shared::FlashMessages, context.flash
        content
      end
    end
  end

  private def app_domain
    URI.parse(Home::Index.url).normalize
      .to_s
      .sub(/\/$/, "")
      .sub(/^https?:\/\//, "")
  end
end

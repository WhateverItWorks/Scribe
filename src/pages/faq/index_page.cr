class Faq::IndexPage < MainLayout
  def page_title
    "Scribe FAQ"
  end

  def content
    h1 "Frequently Asked Questions"
    article do
      auto_redirect
      custom_domains
      why_would_i_want_this
      other_instances
      mount Shared::LayoutFooter
    end
  end

  private def auto_redirect
    section do
      h2 "How-to Automatically Redirect Medium Articles"
      para do
        text "If you don't want to manually change the URL every time, you can use an extension to do it for you. The "
        a "LibRedirect extention", href: "https://libredirect.github.io/"
        text " works well across most browsers, and will also redirect to other alternative services."
      end
    end
  end

  private def custom_domains
    section do
      a name: "custom-domains"
      h2 "What about Medium articles on custom domains?"
      para do
        text <<-TEXT
          Scribe can read these also. The URL just needs to end with the
          characters at the end of the URL called the Post ID. Here's an
          example:
        TEXT
      end
      para do
        code "example.com/my-post-"
        code "09a6af907a2", class: "highlight"
        text " can be converted to "
        br
        code app_domain
        code "/my-post-"
        code "09a6af907a2", class: "highlight"
      end
      para do
        text <<-TEXT
          The instructions above may redirect custom domains automatically. To
          manually redirect a specific custom domain to Scribe, add another
          redirect and replace
        TEXT
        text " "
        code "medium\\.com", class: "highlight"
        text " with the domain of your choosing."
      end
    end
  end

  private def why_would_i_want_this
    section do
      h2 "Why Would I Want to Use This?"
      para do
        text "There are a number of potential reasons:"
        ul do
          li do
            text "You believe in an "
            a "open web", href: "http://scripting.com/liveblog/users/davewiner/2016/01/20/0900.html"
          end
          li do
            text "You believe more in "
            a "the author", href: "https://www.manton.org/2016/01/15/silos-as-shortcuts.html"
            text " than the platform"
          end
          li do
            text "You "
            a "don't like the reading experience", href: "https://twitter.com/BretFisher/status/1206766086961745920"
            text " that Medium provides"
          end
          li do
            text "You object to "
            a "Medium's extortionist business tactics", href: "https://www.cdevn.com/why-medium-actually-sucks/"
          end
          li do
            text "You're concerned about how "
            a "Medium uses your data", href: "https://tosdr.org/en/service/1003"
          end
          li do
            a "Other reasons", href: "https://nomedium.dev/"
          end
        end
      end
    end
  end

  private def other_instances
    section do
      h2 "Can I use Scribe on a different website? (instances)"
      para do
        text "You can! See "
        a(
          "this list",
          href: "https://git.sr.ht/~edwardloveall/scribe/tree/main/docs/instances.md"
        )
        text " in the documentation."
      end
    end
  end
end

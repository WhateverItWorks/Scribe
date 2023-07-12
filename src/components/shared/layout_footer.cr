class Shared::LayoutFooter < BaseComponent
  def render
    section do
      footer do
        para do
          span do
            a "Source code", href: "https://sr.ht/~edwardloveall/Scribe"
          end
          span do
            text "Version: #{Scribe::VERSION}"
          end
        end
      end
    end
  end
end

class Errors::ShowPage < MainLayout
  needs message : String
  needs status_code : Int32

  def content
    h1 status_code
    h2 message

    article do
      para do
        a "Try heading back to home", href: "/"
      end
    end
  end
end

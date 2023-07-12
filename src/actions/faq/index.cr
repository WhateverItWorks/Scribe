class Faq::Index < BrowserAction
  get "/faq" do
    html Faq::IndexPage
  end
end

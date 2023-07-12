class Articles::ShowPage < MainLayout
  needs page : Page

  def page_title
    page.title
  end

  def content
    h1 page.title
    para class: "meta" do
      text "#{author_link(page.author)} on #{page.created_at.to_s("%F")}"
    end
    article do
      section do
        mount PageContent, page: page
      end
    end
  end

  def author_link(creator : PostResponse::Creator)
    href = Nodes::UserAnchor::USER_BASE_URL + creator.id
    a(href: href) { text creator.name }
  end
end

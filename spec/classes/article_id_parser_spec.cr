require "../spec_helper"

def resource_request(resource : String)
  headers = HTTP::Headers{"Host" => "example.com"}
  HTTP::Request.new("GET", resource, headers)
end

describe ArticleIdParser do
  it "parses the post id for urls like /@user/:post_slug" do
    request = resource_request("/@user/my-post-111111abcdef")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Just.new("111111abcdef"))
  end

  it "parses the post id for urls with hex characters after a /" do
    request = resource_request("/@user/bacon-abcdef123456")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Just.new("abcdef123456"))
  end

  it "parses the post id for urls like /user/:post_slug" do
    request = resource_request("/user/my-post-222222abcdef")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Just.new("222222abcdef"))
  end

  it "parses the post id for urls like /p/:post_slug" do
    request = resource_request("/p/my-post-333333abcdef")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Just.new("333333abcdef"))
  end

  it "parses the post id for urls like /posts/:post_slug" do
    request = resource_request("/posts/my-post-444444abcdef")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Just.new("444444abcdef"))
  end

  it "parses the post id for urls like /p/:post_id" do
    request = resource_request("/p/555555abcdef")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Just.new("555555abcdef"))
  end

  it "parses the post id for urls like /:post_slug" do
    request = resource_request("/my-post-666666abcdef")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Just.new("666666abcdef"))
  end

  it "parses the post id for urls like /https:/medium.com/@user/:post_slug" do
    request = resource_request("/https:/medium.com/@user/777777abcdef")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Just.new("777777abcdef"))
  end

  it "parses the post id for global identity redirects" do
    request = resource_request("/m/global-identity?redirectUrl=https%3A%2F%2Fexample.com%2Fmy-post-888888abcdef")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Just.new("888888abcdef"))
  end

  it "parses the post id for global identity 2 redirects" do
    request = resource_request("/m/global-identity-2?redirectUrl=https%3A%2F%2Fexample.com%2Fmy-post-999999abcdef")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Just.new("999999abcdef"))
  end

  it "returns Nothing if path is a username" do
    request = resource_request("/@ba5eba11")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Nothing(String).new)
  end

  it "returns Nothing if path is a tag" do
    request = resource_request("/tag/0ddba11")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Nothing(String).new)
  end

  it "returns Nothing if path is search result" do
    request = resource_request("/search?q=ba5eba11")

    result = ArticleIdParser.parse(request)

    result.should eq(Monads::Nothing(String).new)
  end
end

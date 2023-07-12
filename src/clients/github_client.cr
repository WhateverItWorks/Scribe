class GithubClient
  class SuccessfulResponse
    getter data : HTTP::Client::Response

    def initialize(@data : HTTP::Client::Response)
    end
  end

  class RateLimitedResponse
  end

  def self.get_gist_response(id : String) : SuccessfulResponse | RateLimitedResponse
    new.get_gist_response(id)
  end

  def get_gist_response(id : String) : SuccessfulResponse | RateLimitedResponse
    client = HTTP::Client.new("api.github.com", tls: true)
    if username && password
      client.basic_auth(username, password)
    end
    response = client.get("/gists/#{id}")
    if response.status == HTTP::Status::FORBIDDEN &&
       response.headers["X-RateLimit-Remaining"] == "0"
      RateLimitedResponse.new
    else
      SuccessfulResponse.new(response)
    end
  end

  private def username
    ENV["GITHUB_USERNAME"]?
  end

  private def password
    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"]?
  end
end

module ActionHelpers
  private def action_context(path = "/")
    io = IO::Memory.new
    request = HTTP::Request.new("GET", path)
    response = HTTP::Server::Response.new(io)
    HTTP::Server::Context.new(request, response)
  end

  private def params
    {} of String => String
  end
end

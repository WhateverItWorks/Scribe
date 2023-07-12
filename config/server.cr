Lucky::Server.configure do |settings|
  if LuckyEnv.production?
    settings.secret_key_base = secret_key_from_env
    settings.host = "0.0.0.0"
    settings.port = ENV["PORT"].to_i
    settings.gzip_enabled = true
    # To add additional extensions do something like this:
    # settings.gzip_content_types << "content/type"
    # https://github.com/luckyframework/lucky/blob/master/src/lucky/server.cr
  else
    settings.secret_key_base = "QRpx5Ugh3/S5QCJZNScwNI7HcBdi8jBdtU7iDX5RRcE="
    settings.host = Lucky::ServerSettings.host
    settings.port = Lucky::ServerSettings.port
  end
  settings.asset_host = "" # Lucky will serve assets
end

Lucky::ForceSSLHandler.configure do |settings|
  # To force SSL in production, uncomment the lines below.
  # This will cause http requests to be redirected to https:
  #
  #    settings.enabled = LuckyEnv.production?
  #    settings.strict_transport_security = {max_age: 1.year, include_subdomains: true}
  #
  # Or, leave it disabled:
  settings.enabled = false
end

# Set a uniuqe ID for each HTTP request.
Lucky::RequestIdHandler.configure do |settings|
  # To enable the request ID, uncomment the lines below.
  # You can set your own custom String, or use a random UUID.
  #
  # settings.set_request_id = ->(context : HTTP::Server::Context) {
  #   UUID.random.to_s
  # }
end

private def secret_key_from_env
  ENV["SECRET_KEY_BASE"]? || raise_missing_secret_key_in_production
end

private def raise_missing_secret_key_in_production
  puts "Please set the SECRET_KEY_BASE environment variable. You can generate a secret key with 'lucky gen.secret_key'".colorize.red
  exit(1)
end

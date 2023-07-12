require "./server"

Lucky::Session.configure do |settings|
  settings.key = "_scribe_session"
end

Lucky::CookieJar.configure do |settings|
  settings.on_set = ->(cookie : HTTP::Cookie) {
    cookie.secure(Lucky::ForceSSLHandler.settings.enabled)
    cookie.http_only(true)
    cookie.samesite(:lax)
    cookie.path("/")
  }
end

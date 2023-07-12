Lucky::RouteHelper.configure do |settings|
  if LuckyEnv.production?
    settings.base_uri = ENV.fetch("APP_DOMAIN")
  else
    settings.base_uri = "http://localhost:#{Lucky::ServerSettings.port}"
  end
end

Lucky::HTMLPage.configure do |settings|
  settings.render_component_comments = !LuckyEnv.production?
end

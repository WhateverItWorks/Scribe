module Application
  Habitat.create do
    setting name : String
  end
end

Application.configure do |settings|
  settings.name = "Scribe"
end

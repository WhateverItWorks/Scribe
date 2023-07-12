class UnusedDB < Avram::Database
end

UnusedDB.configure do |settings|
  settings.credentials = Avram::Credentials.void
end

Avram.configure do |settings|
  settings.database_to_migrate = UnusedDB
end

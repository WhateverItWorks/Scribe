require "../../../spec/support/factories/**"

class Db::Seed::RequiredData < LuckyTask::Task
  summary "Add database records required for the app to work"

  def call
    # Avram::Factory:
    # UserFactory.create &.email("me@example.com")

    # SaveOperation:
    # SaveUser.create!(email: "me@example.com", name: "Jane")
    puts "Done adding required data"
  end
end

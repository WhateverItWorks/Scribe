require "../../../spec/support/factories/**"

class Db::Seed::SampleData < LuckyTask::Task
  summary "Add sample database records helpful for development"

  def call
    # Avram::Factory:
    # UserFactory.create &.email("me@example.com")

    # SaveOperation:
    # SaveUser.create!(email: "me@example.com", name: "Jane")
    puts "Done adding sample data"
  end
end

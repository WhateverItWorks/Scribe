# https://luckyframework.org/guides/command-line-tasks/custom-tasks

ENV["LUCKY_TASK"] = "true"

require "./src/app"
require "lucky_task"
require "./tasks/**"
require "./db/migrations/**"
require "lucky/tasks/**"
require "avram/lucky/tasks"

LuckyTask::Runner.run

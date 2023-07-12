ENV["LUCKY_ENV"] = "test"
ENV["DEV_PORT"] = "5001"
require "spec"
require "lucky_flow"
require "lucky_flow/ext/lucky"
require "lucky_flow/ext/avram"
require "../src/app"
require "./support/flows/base_flow"
require "./support/**"
require "../db/migrations/**"
require "./setup/**"

include Lucky::RequestExpectations
include LuckyFlow::Expectations

Avram::Migrator::Runner.new.ensure_migrated!
Avram::SchemaEnforcer.ensure_correct_column_mappings!
Habitat.raise_if_missing_settings!

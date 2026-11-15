require "test_helper"
require "erb"
require "yaml"

class DatabaseConfigurationTest < ActiveSupport::TestCase
  test "development defaults to the external database directory" do
    previous = ENV.delete("LANDING_DB_DIR")
    config = YAML.safe_load(ERB.new(Rails.root.join("config/database.yml").read).result, aliases: true)

    assert_equal File.join(Dir.home, "azinger.io", "db", "development.sqlite3"), config.dig("development", "database")
    assert_equal "storage/production.sqlite3", config.dig("production", "primary", "database")
  ensure
    ENV["LANDING_DB_DIR"] = previous
  end

  test "database directory override keeps environments and production databases separate" do
    previous = ENV["LANDING_DB_DIR"]
    ENV["LANDING_DB_DIR"] = "/tmp/landing-databases"
    config = YAML.safe_load(ERB.new(Rails.root.join("config/database.yml").read).result, aliases: true)

    assert_equal "/tmp/landing-databases/development.sqlite3", config.dig("development", "database")
    assert_equal "storage/test.sqlite3", config.dig("test", "database")
    %w[primary cache queue cable].each do |name|
      suffix = name == "primary" ? "" : "_#{name}"
      assert_equal "/tmp/landing-databases/production#{suffix}.sqlite3", config.dig("production", name, "database")
    end
  ensure
    ENV["LANDING_DB_DIR"] = previous
  end
end

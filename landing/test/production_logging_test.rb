require "test_helper"
require "open3"
require "tmpdir"

class ProductionLoggingTest < ActiveSupport::TestCase
  test "production prefixes tagged and untagged messages in both destinations" do
    Dir.mktmpdir do |log_dir|
      env = {
        "RAILS_ENV" => "production",
        "LANDING_LOG_DIR" => log_dir,
        "SECRET_KEY_BASE_DUMMY" => "1",
        "RAILS_LOG_LEVEL" => "info"
      }
      code = 'Rails.logger.tagged("request-123") { Rails.logger.info("request message") }; Rails.logger.info("job message")'
      stdout, stderr, status = Open3.capture3(env, RbConfig.ruby, Rails.root.join("bin/rails").to_s, "runner", code)

      assert status.success?, stderr
      [ stdout, File.read(File.join(log_dir, "production.log")) ].each do |output|
        assert_includes output, "[landing] [request-123] request message\n"
        assert_includes output, "[landing] job message\n"
      end
    end
  end
end

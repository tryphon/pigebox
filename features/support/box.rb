require 'vmbox'
require 'open-uri'
require 'fileutils'

def current_box
  @current_box = VMBox.new("pigebox").tap do |vmbox|
    vmbox.ignored_status_details << /^pige_/
  end
end

After do |scenario|
  if scenario.failed?
    open("http://pigebox.local/log.gz", "rb") do |read_file|
      File.open("log/cucumber-syslog-#{Time.now.to_i}.gz", "wb") do |saved_file|
        FileUtils.copy_stream read_file, saved_file
      end
    end
  end

  retry_count = 0
  begin
    current_box.rollback
  rescue Timeout::Error => e
    retry_count += 1
    VMBox.logger.error "Rollback failed : #{e}"
    if retry_count < 10
      retry
    else
      VMBox.logger.error "Stop tests"
      Cucumber.wants_to_quit = true
    end
  end
end

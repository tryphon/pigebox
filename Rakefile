require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

Dir['tasks/**/*.rake'].each { |t| load t }

SystemBuilder::MultiArchBoxTasks.new(:pigebox) do |box|
  # Ignore some status details (especially for vm:start_and_save)
  box.vmbox.ignored_status_details << /^pige_/
end

require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

Dir['tasks/**/*.rake'].each { |t| load t }

SystemBuilder::BoxTasks.new(:pigebox) do |box|
  box.boot do |boot|
    boot.version = :wheezy
    boot.architecture = :amd64
  end

  # Ignore some status details (especially for vm:start_and_save)
  box.vmbox.ignored_status_details << /^pige_/
end

desc "Run continuous integration tasks"
task :ci => "pigebox:ci"

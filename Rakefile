require 'system_builder/tasks'

SystemBuilder.define_tasks(:pigebox, multiple_architecture: true) do |box|
  # Ignore some status details (especially for vm:start_and_save)
  box.vmbox.ignored_status_details << /^pige_/
end

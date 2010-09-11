require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

SystemBuilder::BoxTasks.new(:pigebox)
task :buildbot => "pigebox:buildbot"

namespace :pigebox do
  namespace :storage do
    desc "Create storage disk"
    task :create do
      sh "qemu-img create -f qcow2 dist/storage 10G"
    end
  end
end


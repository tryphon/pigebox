require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

SystemBuilder::BoxTasks.new(:pigebox)
task :buildbot => "pigebox:buildbot"

namespace :pigebox do
  namespace :storage do

    task :clean do
      rm Dir["dist/storage*"]
    end

    def create_disk(name, size = "10G")
      sh "qemu-img create -f qcow2 dist/#{name} 10G"
    end

    desc "Create storage disk"
    task :create, :disk_count do |t, args|
      args.with_defaults(:disk_count => 1)

      disk_count = args.disk_count.to_i

      if disk_count.to_i > 1
        disk_count.times { |n| create_disk "storage#{n+1}" }
      else
        create_disk "storage"
      end
    end
  end
end


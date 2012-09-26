require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

SystemBuilder::BoxTasks.new(:pigebox) do |box|
  box.disk_image do |image|
    image.size = 500.megabytes
  end
end

desc "Run continuous integration tasks"
task :ci => "pigebox:buildbot"

namespace :pigebox do
  namespace :storage do

    task :clean do
      rm Dir["dist/storage*"]
    end

    def create_disk(name, size)
      sh "qemu-img create -f raw dist/#{name} #{size}"
    end

    desc "Create storage disk"
    task :create, [:disk_count, :size] do |t, args|
      args.with_defaults(:disk_count => 1, :size => ENV.fetch("STORAGE_SIZE", "5G"))

      disk_count = args.disk_count.to_i

      if disk_count.to_i > 1
        disk_count.times { |n| create_disk "storage#{n+1}", args.size }
      else
        create_disk "storage", args.size
      end
    end
  end
end


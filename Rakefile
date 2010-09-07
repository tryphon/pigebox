require 'rubygems'

require 'system_builder'
require 'system_builder/task'

["#{ENV['HOME']}/.system_builder.rc", "./local.rb"].each do |conf|
  load conf if File.exists?(conf)
end

Dir['tasks/**/*.rake'].each { |t| load t }

SystemBuilder::Task.new(:pigebox) do
  SystemBuilder::DiskSquashfsImage.new("dist/disk").tap do |image|
    image.boot = SystemBuilder::DebianBoot.new("build/root")
    image.boot.configurators << SystemBuilder::PuppetConfigurator.new
		image.size = 200.megabytes
  end
end

namespace :pigebox do
  namespace :storage do
    desc "Create storage disk"
    task :create do
      sh "qemu-img create -f qcow2 dist/storage 10G"
    end
  end
end

task :setup => "pigebox:setup"

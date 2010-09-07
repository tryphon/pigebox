namespace :buildbot do
  task :dist do
    mkdir_p target_directory = "#{ENV['HOME']}/dist/pigebox"
    cp "dist/disk", "#{target_directory}/disk-#{Time.now.strftime("%Y%m%d-%H%M")}"
  end
end

task :buildbot => [:clean, "pigebox:dist", "buildbot:dist", :clean]

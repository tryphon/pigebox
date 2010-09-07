desc "Setup your environment to build an image"
task :setup do
  if ENV['WORKING_DIR']
    %w{build dist}.each do |subdir|
      working_subdir = File.join ENV['WORKING_DIR'], subdir
      unless File.exists?(working_subdir)
        puts "* create and link #{working_subdir}"
        mkdir_p working_subdir
      end
      ln_sf working_subdir, subdir unless File.exists?(subdir)
    end
  end
end


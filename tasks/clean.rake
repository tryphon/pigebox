task :clean do
  sh "sudo sh -c \"fuser $PWD/build/root || rm -r build/root\"" if File.exists?("build/root")
  sh "rm -f dist/*"
end

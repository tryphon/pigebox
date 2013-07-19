# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

#Set default timezone to the cute city of Paris
config.time_zone = 'Paris'

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.after_initialize do
  Chunk.storage_directory = "/srv/pige/chunks"

  PuppetConfiguration.configuration_file = "/var/etc/puppet/manifests/config.pp"
  PuppetConfiguration.system_update_command = "sudo /usr/local/sbin/launch-puppet"
  
  # SavePoint.timestamp_file = "/boot/config.pp"
  SavePoint.save_command = "sudo /usr/local/sbin/save-puppet-config"

  Pige::Record::Index.record_directory = "/srv/pige/records"
end

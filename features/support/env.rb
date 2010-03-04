# -*- coding: undecided -*-
require 'cucumber'

require 'spec'
require "spec/expectations"

require 'cucumber/formatter/unicode'
require 'cucumber/web/tableish'

require 'webrat'
require 'webrat/core/matchers'

Webrat.configure do |config|
  config.mode = :mechanize
  # Set to true if you want error pages to pop up in the browser
  config.open_error_files = false 
end

class WebratWorld
  include Spec::Matchers
  include Webrat::Methods
  include Webrat::Matchers
end

World do
  WebratWorld.new
end


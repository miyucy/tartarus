$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'spec'
require 'spec/autorun'

require 'rubygems'
require 'action_controller'
require 'action_controller/test_process'
require 'active_record'
require 'active_record/base'
require 'active_support'

require 'exceptional'

# Stub out some Rails enviroment variables so we don't have to load an 
# entire rails enviroment to run the specs.
module Rails
  def self.env
    'test'
  end

  def self.root
    '/apps/myapp'
  end
end

Spec::Runner.configure { |config| }




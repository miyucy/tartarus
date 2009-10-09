require 'yaml'

class Exceptional
   def self.configuration
     return @cached_config if @cached_config
     configuration_file = YAML.load_file("#{Rails.root}/config/exceptional.yml")
     @cached_config ||= configuration_file[Rails.env]
   end
end

require 'exceptional/logger'

require 'yaml'
require 'will_paginate'

class Tartarus
  class << self
    def configuration
      @cached_config ||= YAML.load_file("#{Rails.root}/config/exceptions.yml")[Rails.env]
    end

    def logger_class
      configuration['logger_class'].constantize
    end
    
    def logging_enabled?
      configuration['logging_enabled'] == true
    end

    def log(controller, exception)
      logger_class.log(controller, exception)
    end
  end
end

require 'tartarus/logger'
require 'tartarus/rescue'

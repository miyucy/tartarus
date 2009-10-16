require 'yaml'

class Exceptional
  class << self
    def configuration
      @cached_config ||= YAML.load_file("#{Rails.root}/config/exceptional.yml")[Rails.env]
    end

    def logger_class
      configuration['logger_class'].constantize
    end

    def log(controller, exception)
      logger_class.log(controller, exception)
    end
  end

end

require 'exceptional/logger'
require 'exceptional/rescue'

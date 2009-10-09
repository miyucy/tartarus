require 'exceptional'

if defined?(ActionController::Base)
  ActionController::Base.send(:include, Exceptional::Logger)
end

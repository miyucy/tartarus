require 'exceptional'
ActionController::Base.send(:include, Exceptional::Rescue)

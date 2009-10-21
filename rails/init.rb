require 'tartarus'

ActionController::Base.send(:include, Tartarus::Rescue)

ENV["RAILS_ENV"] = "test"

require File.expand_path(File.dirname(__FILE__) + "/rails/config/environment")
require "#{File.expand_path(File.dirname(__FILE__))}/../rails/init"
require 'spec'
require 'spec/rails'


def fake_controller_request
  stub('request',
       :env => {
         'HTTP_HOST' => 'test_host',
         'KEY_ONE' => 'key_one_value',
         'LOOOOOOOONG_KEY_TWO' => 'key_two_value',
         'rack.session' => { :id => '123123' },
         'rack.session.options' => {},
         'rack.request.cookie_hash' => {}
       },
       :method => 'post',
       :parameters => 'params',
       :format => 'html',
       :protocol => 'http://',
       :request_uri => '/my/uri')     
end

class LoggedException < ActiveRecord::Base
  include Tartarus::Logger
end

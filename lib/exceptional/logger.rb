module Exceptional::Logger
  def self.included(base)
    base.extend ClassMethods
    base.serialize :request
  end

  module ClassMethods
    def log(controller, exception)
      create do |logged_exception|
        hash_id = "#{exception.class.name}#{exception.message}#{controller.controller_path}#{controller.action_name}"     
        logged_exception.exception_class = exception.class.name
        logged_exception.controller_path = controller.controller_path
        logged_exception.action_name = controller.action_name
        logged_exception.message = exception.message
        logged_exception.backtrace = exception.backtrace * "\n"
        logged_exception.request = normalize_request_data(controller.request)
        logged_exception.hash_id = Digest::SHA1.hexdigest(hash_id)
      end
    end

    def normalize_request_data(request)
      request_details = {
        :enviroment => {},
        :http_details => { 
          :method => request.method.to_s.upcase,
          :url => "#{request.protocol}#{request.env["HTTP_HOST"]}#{request.request_uri}",
          :format => request.format.to_s,
          :parameters => request.parameters
        },

        :session => {
          :variables => request.env['rack.session'],
          :options => request.env['rack.session.options'],
          :cookie => request.env['rack.request.cookie_hash']
        }
      }

      request.env.each_pair do |key, value|
        request_details[:enviroment][key.downcase] = value if key.match(/^[A-Z_]*$/)
      end

      return request_details
    end
  end
end

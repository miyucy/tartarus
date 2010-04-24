module Tartarus::Logger
  def self.included(base)
    base.extend ClassMethods
    base.serialize :request
  end

  module ClassMethods
    def log(controller, exception)
      create do |logged_exception|
        group_id = "#{exception.class.name}#{exception.message}#{controller.controller_path}#{controller.action_name}" 
    
        logged_exception.exception_class = exception.class.name
        logged_exception.controller_path = controller.controller_path
        logged_exception.action_name = controller.action_name
        logged_exception.message = exception.message
        logged_exception.backtrace = sanitize_backtrace(exception.backtrace) * "\n"
        logged_exception.request = normalize_request_data(controller.request)
        logged_exception.group_id = Digest::SHA1.hexdigest(group_id)
      end
    end

    def normalize_request_data(request)
      enviroment = request.env.dup

      request_details = {
        :enviroment => { :process => $$, :server => `hostname -s`.chomp },
        :session => { :variables => enviroment['rack.session'].to_hash, :cookie => enviroment['rack.request.cookie_hash'] },
        :http_details => { 
          :method => request.method.to_s.upcase,
          :url => "#{request.protocol}#{request.env["HTTP_HOST"]}#{request.request_uri}",
          :format => request.format.to_s,
          :parameters => request.parameters
        }
      }

      enviroment.each_pair do |key, value|
        request_details[:enviroment][key.downcase] = value if key.match(/^[A-Z_]*$/)
      end

      return request_details
    end

    private

    def sanitize_backtrace(backtrace)
      unless @cleaner
        @cleaner = ActiveSupport::BacktraceCleaner.new

        dirs = confdir + gemdir + homedir + railsdir
        dirs.sort_by{ |k, v| -v.size }.each do |name, path|
          @cleaner.add_filter{ |trace| trace.gsub(/^#{Regexp.escape(path)}/, "[#{name.upcase}]") }
        end
      end
      @cleaner.clean backtrace
    end

    def confdir
      require 'rbconfig'
      Config::CONFIG.select{ |k,v| k =~ /dir$/ }
    end

    def gemdir
      Gem.path.map{ |v| ["gemdir", v]}
    end

    def homedir
      [["home", File.expand_path("~")]]
    end

    def railsdir
      [["rails", Rails.root.to_s]]
    end
  end
end

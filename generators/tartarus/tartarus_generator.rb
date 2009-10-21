class TartarusGenerator < Rails::Generator::NamedBase
  default_options :skip_migration => false

  def initialize(runtime_args, runtime_options = {})
    runtime_args << 'LoggedException' if runtime_args.empty?
    super
  end
  
  def manifest
    record do |m|      
      puts "\nGenerated files:\n"
      # Directories
      m.directory "app/views/exceptions"
      m.directory 'spec/models'

      # Configuration
      m.template 'config/exceptions.yml', 'config/exceptions.yml'

      #Migration        
      m.migration_template "db/migrate/add_logged_exceptions.rb", "db/migrate", :migration_file_name => "add_#{singular_name}_table"

      # Controllers
      m.template 'app/controllers/exceptions_controller.rb', "app/controllers/exceptions_controller.rb"

      # Views
      Dir.glob( File.dirname(__FILE__) + '/templates/app/views/exceptions/*.html.erb').each do |path| 
        view = File.basename( path )
        m.file "app/views/exceptions/#{view}", "app/views/exceptions/#{view}"
      end

      # Models
      m.template 'app/models/logged_exception.rb', "app/models/#{file_name}.rb"

      # Specs
      m.template 'spec/models/logged_exception_spec.rb', "spec/models/#{file_name}_spec.rb"

      # Public
      m.file 'public/javascripts/tartarus.jquery.js', 'public/javascripts/tartarus.jquery.js'
      m.file 'public/stylesheets/tartarus.css', 'public/stylesheets/tartarus.css'
    end
  end

  def after_generate
    puts "\nIn order for exceptional to function properly, you'll need to complete the following steps to complete the installation process: \n\n"
    puts "  1) Run 'rake db:migrate' to generate the logging table for your model.\n"
    puts "  2) Add '/javascripts/tartarus.jquery.js', and 'stylesheets/tartarus.css' to your applications layout.\n"
    puts "  3) View 'config/exceptions.yml' and make sure the default options are correct.\n\n"
  end
end

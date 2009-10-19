class ExceptionalGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # Configuration and Migration
      m.template 'config/exceptional.yml', 'config/exceptional.yml'
      m.migration_template "db/migrate/add_#{table_name}.rb", "db/migrate", :migration_file_name => "add_#{singular_name}_table"

      # Controllers
      m.template 'app/controllers/exceptions_controller.rb', "app/controllers/exceptions_controller.rb"

      # Views
      m.directory "app/views/exceptions"
 
      Dir.glob( File.dirname(__FILE__) + '/templates/app/views/exceptions/*.html.erb').each do |path| 
        view = File.basename( path )
        m.file "app/views/exceptions/#{view}", "app/views/exceptions/#{view}"
      end

      # Models
      m.template 'app/models/logged_exception.rb', "app/models/#{file_name}.rb"

      # Specs
      m.directory 'spec/models'      
      m.template 'spec/models/logged_exception_spec.rb', "spec/models/#{file_name}_spec.rb"

      # Public
      m.file 'public/javascripts/exceptional.jquery.js', 'public/javascripts/exceptional.jquery.js'
      m.file 'public/stylesheets/exceptional.css', 'public/stylesheets/exceptional.css'
    end
  end 
end

class ExceptionalGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # Configuration and Migration
      m.template 'config/exceptional.yml', 'config/exceptional.yml'
      m.migration_template "db/migrate/add_#{table_name}.rb", "db/migrate", :migration_file_name => "add_#{singular_name}_table"

      # Models
      m.template 'app/models/logged_exception.rb', "app/models/#{file_name}.rb"

      # Specs
      m.directory 'spec/models'      
      m.template 'spec/models/logged_exception_spec.rb', "spec/models/#{file_name}_spec.rb"
    end
  end
 
end

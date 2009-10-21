class Add<%= class_name %>Table < ActiveRecord::Migration
  def self.up
    create_table :<%= plural_name %>, :force => true do |t|
      t.string   :group_id
      t.string   :exception_class
      t.string   :controller_path
      t.string   :action_name
      t.text     :message
      t.text     :backtrace
      t.text     :request
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :<%= plural_name %>
  end
end

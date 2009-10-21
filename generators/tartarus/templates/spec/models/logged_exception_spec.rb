require File.dirname(__FILE__) + '/../spec_helper'

describe <%= class_name %> do 
  it "should include the Tartarus::Logger module" do
    <%= class_name %>.included_modules.include?(Tartarus::Logger)
  end
end

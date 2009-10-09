require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Exceptional, 'if ActionController::Base is defined' do
  it 'should extend ActionController::Base with Execeptional::Logger' do
    ActionController::Base.included_modules.include?(Exceptional::Logger)
  end
end

describe Exceptional, "#configuration" do
  before(:each) do
    YAML.stub!(:load_file).and_return({'development' => { 'enabled' => true }, 'test' => { 'enabled' => false } })
  end

  it 'should parse the YAML configuration file for exceptional' do
    YAML.should_receive(:load_file).with("/apps/myapp/config/exceptional.yml")
    Exceptional.configuration
  end

  it 'should return the configuration from the current rails enviroment' do
    Exceptional.configuration.should == { 'enabled' => false }
  end
 
  it 'should return a cached config if the configuration has already been loaded before' do
    Exceptional.configuration
    YAML.should_receive(:load_file).never
    Exceptional.configuration.should == { 'enabled' => false }
  end
end

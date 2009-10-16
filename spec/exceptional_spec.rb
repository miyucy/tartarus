require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Exceptional do
  it 'should include rescue module into ActionController::Base if a rails enviroment is loaded' do
    ActionController::Base.included_modules.include?(Exceptional::Rescue).should be_true
  end

  describe "#logger_class" do
    it 'should return the registered loggers class from the configuration' do
      Exceptional.should_receive(:configuration).and_return({ 'logger_class' => 'LoggedException' })
      Exceptional.logger_class.should == LoggedException
    end
  end

  describe "#log" do
    before(:each) do
      @controller = mock('controller')
      @exception = StandardError.new
      Exceptional.stub!(:logger_class).and_return(LoggedException)
    end

    it 'should proxy the log call to the registered logger class' do
      LoggedException.should_receive(:log).with(@controller, @exception)
      Exceptional.log(@controller, @exception)
    end

    it 'should return an instance of the registered logger class' do
      LoggedException.stub!(:log).and_return(LoggedException.new)
      Exceptional.log(@controller, @exception).should be_an_instance_of(LoggedException)
    end
  end

  describe "#configuration" do
    before(:each) do
      YAML.stub!(:load_file).and_return({'development' => { 'enabled' => true }, 'test' => { 'enabled' => false } })
    end

    it 'should parse the YAML configuration file for exceptional' do
      YAML.should_receive(:load_file).with("#{Rails.root}/config/exceptional.yml")
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
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tartarus::Logger do
  it 'should serialize the request attribute' do
    LoggedException.serialized_attributes.include?('request').should be_true
  end

  describe "#log" do
    before(:each) do
      LoggedException.stub!(:normalize_request_data).and_return({})
      @controller = mock('controller', :controller_path => 'home', :action_name => 'index', :request => fake_controller_request)
      @exception = StandardError.new('An error has occured!')
      @exception.stub!(:backtrace).and_return(['one', 'two', 'three'])
    end

    it "should create a group_id for grouping of exceptions that are the same" do
      @logged_exception = LoggedException.log(@controller, @exception)
      @logged_exception.group_id.should == 'ea61658eacfe0930ae2b318297ab51a3c0b5668c'
    end

    it "should convert the backtrace from an array to a string seperated by newlines" do
      @logged_exception = LoggedException.log(@controller, @exception)
      @logged_exception.backtrace.should be_an_instance_of(String)
      @logged_exception.backtrace.should == "one\ntwo\nthree"
    end

    it "should normalize the controller request data" do
      LoggedException.should_receive(:normalize_request_data).with(@controller.request)
      @logged_exception = LoggedException.log(@controller, @exception)
    end

    it "should return an instance of the registered logger class" do
      @logged_exception = LoggedException.log(@controller, @exception)
      @logged_exception.should be_an_instance_of(LoggedException)
    end
  end

  describe "#normalize_request_data" do
    before(:each) do
       @request_data = LoggedException.normalize_request_data(fake_controller_request)
    end
    
    it 'should have a enviroment hash that contains a hash of only the uppercase keys of the original controller request hash' do
      @request_data[:enviroment].should_not be_blank
      @request_data[:enviroment].should == { "http_host" => "test_host", "loooooooong_key_two" => "key_two_value", "key_one" => "key_one_value", :server => `hostname -s`.chomp, :process => $$ }
    end

    it 'should have a session hash' do
      @request_data[:session].should_not be_blank
      @request_data[:session].should be_an_instance_of(Hash)
      @request_data[:session].should == { :cookie => {}, :variables => { :id=>"123123" } }
    end

    it 'should have a http details hash' do
      @request_data[:http_details].should_not be_blank
      @request_data[:http_details].should == { :parameters => "params", :format => "html", :method => "POST", :url => "http://test_host/my/uri" }
    end

    it "should return a hash of request data" do
      @request_data.should be_an_instance_of(Hash)
    end
     
  end
end

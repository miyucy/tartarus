require File.dirname(__FILE__) + '/../spec_helper'

describe ExceptionsController do 
  before(:each) do
    @exception = <%= class_name %>.new
  end

  describe "#index" do
    it 'should set an assigns of exceptions with the collection of all exception groups' do
      <%= class_name %>.should_receive(:all).with(:select => '*, COUNT(*) as count', :group => 'group_id', :order => 'created_at DESC').and_return([@exception])

      get :index
      assigns[:exceptions].should == [@exception]
    end
  end

  describe "#details" do
    before(:each) do
      @exception2 = <%= class_name %>.new
      <%= class_name %>.stub!(:paginate).and_return([@exception, @exception2])
    end

    it 'should set an assigns of exceptions with a paginated collection' do
      <%= class_name %>.should_receive(:paginate).with(:all, :conditions => { :group_id => '89hasd98ashdasas98dhsda' }, 
                                                     :order => 'created_at DESC', :page => '1', :per_page => 1).and_return([@exception, @exception2])

      get :details, :id => '89hasd98ashdasas98dhsda', :page => 1
      assigns[:exceptions].should == [@exception, @exception2]
    end

    it 'should set an assigns of exception with the first exception from the paginated collection' do
      get :details, :id => '89hasd98ashdasas98dhsda'
      assigns[:exception].should == @exception
    end
  end
  
  describe "#remove_all" do
    it 'should delete all exceptions' do
      <%= class_name %>.should_receive(:delete_all)
      get :remove_all
    end

    it 'should redirect to exceptions#index' do
      get :remove_all
      response.should redirect_to(:action => :index)
    end
  end

  describe "#remove_group" do
    it 'should delete all exceptions in a specific group' do
      <%= class_name %>.should_receive(:delete_all).with(:group_id => '892h39fds')
      get :remove_group, :id => '892h39fds'
    end

    it 'should redirect to exceptions#index' do
      get :remove_group, :id => '892h39fds'
      response.should redirect_to(:action => :index)
    end
  end

  describe "#remove_individual" do
    before(:each) do
      <%= class_name %>.stub!(:find_by_id).and_return(@exception)
    end

    it 'should remove a single exception' do
      @exception.should_receive(:destroy)
      get :remove_individual, :id => 1      
    end

    it 'should redirect to exceptions#index if the exception group contains no more exceptions' do
      <%= class_name %>.stub!(:count).and_return(0)
      get :remove_individual, :id => 1
      response.should redirect_to(:action => :index)
    end

    it 'should redirect to exceptions#details if the exception group contains more exceptions' do
      <%= class_name %>.stub!(:count).and_return(1)
      get :remove_individual, :id => 1
      response.should redirect_to(:action => :details)
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ExceptionalRescueTestController < ApplicationController
end

describe Exceptional::Rescue do
  before(:each) do
    @controller = ExceptionalRescueTestController.new
  end

  describe 'when mixed into another class' do
    it 'should alias_method_chain rescue_action method with exceptional' do
      @controller.should respond_to(:rescue_action_with_exceptional)
      @controller.should respond_to(:rescue_action_without_exceptional)
    end
  end

  describe "#rescue_action_with_exceptional" do
    before(:each) do
      @exception = StandardError.new
      @controller.stub!(:rescue_action_without_exceptional)
      Exceptional.stub!(:log)
    end

    it 'should log the exception with exceptional' do
      Exceptional.should_receive(:log).with(@controller, @exception)
      @controller.rescue_action_with_exceptional(@exception)
    end

    it 'should invoke rescue_action_without_exceptional' do
      @controller.should_receive(:rescue_action_without_exceptional)
      @controller.rescue_action_with_exceptional(@exception)
    end
  end

  it "should only rescue public exceptions" do
    pending
  end
end


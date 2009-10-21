require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TartarusRescueTestController < ApplicationController
end

describe Tartarus::Rescue do
  before(:each) do
    @controller = TartarusRescueTestController.new
  end

  describe 'when mixed into another class' do
    it 'should alias_method_chain rescue_action method with tartarus' do
      @controller.should respond_to(:rescue_action_with_tartarus)
      @controller.should respond_to(:rescue_action_without_tartarus)
    end
  end

  describe "#rescue_action_with_tartarus" do
    before(:each) do
      @exception = StandardError.new
      @controller.stub!(:rescue_action_without_tartarus)
      @controller.stub!(:response_code_for_rescue).and_return(:internal_server_error)
      Tartarus.stub!(:log)
    end

    it 'should log the exception with tartarus if the exception code should be an internal server error' do
      Tartarus.should_receive(:log).with(@controller, @exception)
      @controller.should_receive(:response_code_for_rescue).and_return(:internal_server_error)
      @controller.rescue_action_with_tartarus(@exception)
    end

    it 'should not log the exception with tartarus if the exception code is not an internal server error' do
      @controller.should_receive(:response_code_for_rescue).and_return(:not_found)
      @controller.rescue_action_with_tartarus(@exception)
    end

    it 'should invoke rescue_action_without_tartarus' do
      @controller.should_receive(:rescue_action_without_tartarus)
      @controller.rescue_action_with_tartarus(@exception)
    end
  end
end


class ExceptionsController < ApplicationController
  def index
    @exceptions = <%= class_name %>.all(:select => '*, COUNT(*) as count', :group => 'hash_id', :order => 'created_at DESC')
  end

  def details
    @exceptions = <%= class_name %>.paginate(:all, :conditions => { :hash_id => params[:id] }, :order => 'created_at DESC', :page => params[:page], :per_page => 1)
    @exception = @exceptions.first
  end
end

class ExceptionsController < ApplicationController
  def index
    @exceptions = <%= class_name %>.all(:select => '*, COUNT(*) as count', :group => 'group_id', :order => 'created_at DESC')
  end

  def details
    @exceptions = <%= class_name %>.paginate(:all, :conditions => { :group_id => params[:id] }, :order => 'created_at DESC', :page => params[:page], :per_page => 1)
    @exception = @exceptions.first
  end

  def remove_all
    <%= class_name %>.delete_all
    redirect_to :action => :index
  end

  def remove_group
    <%= class_name %>.delete_all(:group_id => params[:id])
    redirect_to :action => :index
  end

  def remove_individual
    exception = <%= class_name %>.find_by_id(params[:id])
    exception.destroy

    if <%= class_name %>.count(:conditions => { :group_id => exception.group_id }).zero?
      redirect_to :action => :index
    else
      redirect_to :action => :details, :id => exception.group_id
    end
  end
end

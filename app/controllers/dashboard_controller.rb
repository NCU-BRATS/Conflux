class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout :determine_layout

  def determine_layout
    'dashboard'
  end

  def show

  end

  def projects
    @q  = current_user.projects.page.search( params[:q] )
    @projects = @q.result.uniq.page( params[:page] ).per( params[:per] )
    respond_with @projects
  end

  def issues
    @issues = current_user.issues.page(params[:page]).per(20)
    respond_with @issues
  end

  def attachments
    @attachments = current_user.attachments.page(params[:page]).per(20)
    respond_with @attachments
  end
end
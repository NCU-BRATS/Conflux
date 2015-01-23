class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout :determine_layout

  def determine_layout
    'dashboard'
  end

  def show

  end

  def projects
    @q = current_user.projects.page.search( params[:q] )
    @projects = @q.result.uniq.page( params[:page] ).per( params[:per] )
    respond_with @projects
  end

  def issues
    @issues = Issue.where("user_id = ? OR assignee_id = ?", current_user.id, current_user.id).includes(:user, :assignee, :labels, :project).order('id DESC')
    @q = @issues.search( params[:q] )
    @issues = @q.result.uniq.page( params[:page] ).per( params[:per] )
    respond_with @issues
  end

  def attachments
    @q = current_user.attachments.includes(:project).search( params[:q] )
    @attachments = @q.result.uniq.page( params[:page] ).per( params[:per] )
    respond_with @attachments
  end
end

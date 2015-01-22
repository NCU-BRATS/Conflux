class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout :determine_layout

  def determine_layout
    'dashboard'
  end

  def show

  end

  def projects
    @projects =current_user.projects.page(params[:page]).per(20)
    respond_with @projects
  end

  def issues
    @issues = current_user.issues.page(params[:page]).per(20)
    respond_with @issues
  end
end
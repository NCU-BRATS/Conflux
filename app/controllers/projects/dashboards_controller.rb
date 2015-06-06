class Projects::DashboardsController < Projects::ApplicationController

  def show
    @issues = issues
    @posts  = @project.posts.includes(:user).latest.first(3)
    respond_with @project
  end

  protected

  def model
    :dashboard
  end

  def issues
    params[:issue] ||= 'assigned_to_me'
    case params[:issue]
    when 'opened_by_me'
      @project.issues.includes(:user).open.where(user: current_user).order('id DESC').first(5)
    when 'opened'
      @project.issues.includes(:user).open.order('id DESC').first(5)
    else # default are issues assigned to me
      @project.issues.includes(:user).open.where(assignee: current_user).order('id DESC').first(5)
    end
  end

end

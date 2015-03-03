class Projects::DashboardsController < Projects::ApplicationController

  def show
    @issues = issues
    @posts  = @project.posts.includes(:user).first(5)
    @events = events
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

  def events
    params[:event] ||= 'all'
    if params[:event] == 'all'
      @project.events.includes(:author).order('id DESC')
    elsif params[:event] == 'Attachment'
      @project.events.includes(:author).order('id DESC').where(target_type: Attachment.subclasses)
    else
      @project.events.includes(:author).order('id DESC').where(target_type: params[:event])
    end.page( params[:page] ).per( params[:per] )
  end

end

class Projects::DashboardsController < Projects::ApplicationController

  def show
    @issues = {
      assigned_to_me: @project.issues.includes(:user, :assignee).open.where(assignee: current_user).first(5),
      opened_by_me:   @project.issues.includes(:user, :assignee).open.where(user: current_user).first(5),
      opened:         @project.issues.includes(:user, :assignee).open.first(5)
    }
    @posts = @project.posts.first(5)
    @events = events
    respond_with @project
  end

  protected

  def model
    :dashboard
  end

  def events
    if !(params.has_key?(:type))
      events = @project.events.includes(:project, :author).order('id DESC')
    elsif (params[:type] === 'Attachment')
      events = @project.events.includes(:project, :author).order('id DESC').where('events.target_type = ? OR events.target_type = ? OR events.target_type = ? OR events.target_type = ?','Attachment::Snippet','Attachment::Image','Attachment::Post','Attachment::Other')
    else
      events = @project.events.includes(:project, :author).order('id DESC').where(target_type: params[:type])
    end
    events.uniq.page( params[:page] ).per( params[:per] )
  end

end

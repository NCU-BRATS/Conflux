class Projects::DashboardsController < Projects::ApplicationController
  def show
    @project = Project.friendly.find(params[:project_id])
    @issues = {
      assigned_to_me: @project.issues.includes(:user, :assignee).open.where(assignee: current_user).first(5),
      opened_by_me:   @project.issues.includes(:user, :assignee).open.where(user: current_user).first(5),
      opened:         @project.issues.includes(:user, :assignee).open.first(5)
    }
    @posts = Attachment::Post.first(5)
    respond_with @project
  end
end
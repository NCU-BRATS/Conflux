class Projects::DashboardsController < Projects::ApplicationController

  def show
    @polls   = @project.polls.includes(:user).open.order('id DESC').limit(10)
    @sprints = @project.sprints.includes(:issues).where( archived: false ).order('id DESC').limit(10)
    @issues  = @project.issues.includes(:user).joins(:participations)
                             .where(participations: { user_id: current_user.id })
                             .where.not( status: '2' ).order('id DESC').limit(30)
    respond_with @project
  end

  protected

  def model
    :dashboard
  end

end

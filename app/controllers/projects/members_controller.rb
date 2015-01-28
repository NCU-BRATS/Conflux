class Projects::MembersController < Projects::ApplicationController

  def index
    @q = @project.project_participations.includes(:user).search(params[:q])
    @participations = @q.result.page(params[:page]).per(params[:per])
    respond_with @participations
  end

  def new
    @participation = @project.project_participations.build
    respond_with @participation
  end

  def create
    @participation = @project.project_participations.build(participation_params)
    @participation.save
    respond_with @participation, location: project_members_path
  end

  def destroy
    if @project.project_participations.size > 1
      @participation.destroy
    else
      @participation.errors.add(:base, '')
    end

    respond_with @participation, location: project_members_path
  end

  protected

  def participation_params
    params.require(:project_participation).permit(:user_id)
  end

  def resource
    @participation ||= @project.project_participations.find(params[:id])
  end

  def policy_target
    :project_participation
  end

end

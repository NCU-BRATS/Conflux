class Projects::MembersController < Projects::ApplicationController

  def index
    @participations = @project.project_participations.includes(:user).all
    respond_with @participations
  end

  def new
    @participation = @project.project_participations.build
    authorize @participation
    respond_with @participation
  end

  def create
    @participation = @project.project_participations.build(participation_params)
    authorize @participation
    @participation.save
    respond_with @participation, location: project_members_path
  end

  def destroy
    @participation = @project.project_participations.find(params[:id])
    authorize @participation
    @participation.destroy
    respond_with @participation, location: project_members_path
  end

  protected

    def participation_params
      params.require(:project_participation).permit(:user_id)
    end

end

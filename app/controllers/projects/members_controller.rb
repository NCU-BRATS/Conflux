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
    flash[:notice] = "已成功創建#{ProjectParticipation.model_name.human}" if @participation.save
    respond_with @participation, location: project_members_path
  end

  def destroy
    @participation = @project.project_participations.find(params[:id])
    authorize @participation
    @participation.destroy
    flash[:notice] = "已成功刪除#{ProjectParticipation.model_name.human}"
    respond_with @participation, location: project_members_path
  end

  protected

    def participation_params
      params.require(:project_participation).permit(:user_id)
    end

end

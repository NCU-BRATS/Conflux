class Projects::Settings::MembersController < Projects::SettingsController

  def index
    @q = @project.project_participations.includes(:user).search(params[:q])
    @participations = @q.result.page(params[:page]).per(params[:per])
    respond_with @participations
  end

  def new
    @form = ProjectParticipationOperation::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = ProjectParticipationOperation::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form, location: project_settings_members_path
  end

  def edit
    @form = ProjectParticipationOperation::Update.new(current_user, @project, @participation)
    respond_with @project, @form
  end

  def update
    @form = ProjectParticipationOperation::Update.new(current_user, @project, @participation)
    @form.process(params)
    respond_with @project, @form, location: project_settings_members_path
  end

  def destroy
    @form = ProjectParticipationOperation::Destroy.new(current_user, @project, @participation)
    @form.process
    respond_with @project, @form, location: project_settings_members_path
  end

  protected

  def resource
    @participation ||= @project.project_participations.find(params[:id])
  end

  def model
    ProjectParticipation
  end

  def model_sym
    :member
  end

end

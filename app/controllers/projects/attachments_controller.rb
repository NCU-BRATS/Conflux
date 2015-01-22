class Projects::AttachmentsController < Projects::ApplicationController

  def index
    @q = @project.attachments.search(params[:q])
    @attachments = @q.result.uniq.page(params[:page]).per(params[:per])
    respond_with @attachments
  end

  def new
    @attachment = @project.attachments.build
    authorize @attachment
    respond_with @attachment
  end

  def create
    @attachment = Attachment::intelligent_construct(attachment_params, @project, current_user)
    authorize @attachment
    @attachment.save
    respond_with @attachment, location: project_attachments_path
  end

  def show
    @attachment = @project.attachments.find(params[:id])
    respond_with @attachment
  end

  def destroy
    @attachment = @project.attachments.find(params[:id])
    authorize @attachment
    @attachment.destroy
    respond_with @attachment, location: project_attachments_path
  end

  protected
    def attachment_params
      params.require(:attachment).permit(:name, :path, :path_cache)
    end

end

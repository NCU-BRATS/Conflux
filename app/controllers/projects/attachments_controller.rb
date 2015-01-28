class Projects::AttachmentsController < Projects::ApplicationController

  def index
    @q = @project.attachments.search(params[:q])
    @attachments = @q.result.uniq.latest.page(params[:page]).per(params[:per])
    respond_with @attachments
  end

  def new
    @attachment = @project.attachments.build
    respond_with @attachment
  end

  def create
    @attachment = Attachment::intelligent_construct(attachment_params, @project, current_user)
    @attachment.save
    respond_with @attachment, location: project_attachments_path
  end

  def show
    respond_with @attachment
  end

  def destroy
    @attachment.destroy
    respond_with @attachment, location: project_attachments_path
  end

  def download
    send_data(@attachment.path.url, :filename => @attachment.download_filename)
  end

  protected

  def attachment_params
    params.require(:attachment).permit(:name, :path, :path_cache)
  end

  def set_resourse
    @attachment = @project.attachments.find(params[:id])
  end

end

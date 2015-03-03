class Projects::AttachmentsController < Projects::ApplicationController

  enable_sync only: [:create, :update, :destroy]

  def index
    params[:q] = {type_eq: 'Post'}.merge(params[:q] || {})
    @q = @project.attachments.includes(:user).search(params[:q])
    @attachments = @q.result.uniq.latest.page(params[:page]).per(params[:per])
    respond_with @attachments
  end

  def new
    @attachment = @project.attachments.build
    respond_with @attachment
  end

  def create
    @attachment = Attachment::intelligent_construct(attachment_params, @project, current_user)
    if @attachment.save
      event_service.upload_attachment(@attachment, current_user)
    end
    respond_with @attachment
  end

  def show
    respond_with @attachment
  end

  def destroy
    event_service.delete_attachment(@attachment, current_user)
    @attachment.destroy
    respond_with @attachment, location: project_attachments_path
  end

  def download
    send_data(@attachment.download_data, :filename => @attachment.download_filename)
  end

  protected

  def attachment_params
    params.require(:attachment).permit(:name, :path, :path_cache)
  end

  def resource
    @attachment ||= @project.attachments.find(params[:id])
  end

end

class Projects::AttachmentsController < Projects::ApplicationController

  enable_sync only: [:create, :update, :destroy]

  def index
    params[:q] = {type_eq: 'Post'}.merge(params[:q] || {})
    @q = @project.attachments.includes(:user).search(params[:q])
    @attachments = @q.result.uniq.latest.page(params[:page]).per(params[:per]||5)
    respond_with @project, @attachments
  end

  def show
    if @attachment.type.underscore =~ /(post|snippet)/
      instance_variable_set("@#{$1}", @attachment)
      render "projects/#{$1.pluralize}/show"
    else
      respond_with @project, @attachment
    end
  end

  def new
    @form = AttachmentOperation::Create.new(current_user, @project)
    respond_with @project, @form
  end

  def create
    @form = AttachmentOperation::Create.new(current_user, @project)
    @form.process(params)
    respond_with @project, @form
  end

  def destroy
    @form = AttachmentOperation::Destroy.new(current_user, @project, @attachment)
    @form.process
    respond_with @project, @form, location: project_attachments_path
  end

  def download
    send_data(@attachment.download_data, :filename => @attachment.download_filename)
  end

  protected

  def resource
    @attachment ||= @project.attachments.find(params[:id])
  end

end

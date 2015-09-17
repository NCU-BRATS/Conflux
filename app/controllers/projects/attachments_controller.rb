class Projects::AttachmentsController < Projects::ApplicationController

  def index
    @q = @project.attachments.includes(:user).search(params[:q])
    if params[:q][:type_eq] == 'All'
      @attachments = Attachment.all.latest.page(params[:page]).per(params[:per]||5)
    else
      @attachments = @q.result.uniq.latest.page(params[:page]).per(params[:per]||5)
    end

    respond_with @project, @attachments
  end

  def show
    @private_pub_channel2 = "/attachment/#{@attachment.id}/comments"
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
    if @attachment.path.path
      send_file(@attachment.path.path, :filename => @attachment.download_filename)
    else
      send_data(@attachment.content, :filename => @attachment.download_filename)
    end
  end

  protected

  def resource
    @attachment ||= @project.attachments.find_by_sequential_id(params[:id])
  end

end

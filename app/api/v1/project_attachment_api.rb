module V1
  class ProjectAttachmentAPI < Grape::API
    resources :attachments do

      desc 'attachment index'
      get do
        @attachments = @project.attachments.all
        present @attachments, with: Attachments::AttachmentPreviewEntity
      end

      desc 'attachment create'
      post do
        @form = AttachmentOperation::Create.new(current_user, @project)
        @form.process(ActionController::Parameters.new(attachment: params))
        present @form.model, with: Attachments::AttachmentEntity
      end

      route_param :attachment_id do
        before do
          @attachment ||= @project.attachments.includes(participations: :user).where(sequential_id: params[:attachment_id]).first
        end

        desc 'attachment show'
        get do
          present @attachment, with: Attachments::AttachmentEntity
        end

        desc 'attachment delete'
        delete do
          @form = AttachmentOperation::Destroy.new(current_user, @project, @attachment)
          @form.process
          body false
        end

        desc 'attachment download'
        get :download do
          content_type 'application/octet-stream'
          header['Content-Disposition'] = "attachment; filename=#{@attachment.download_filename}"
          env['api.format'] = :binary
          if @attachment.path.path
            File.binread @attachment.path.path
          else
            @attachment.content
          end
        end

        desc 'show comments'
        get :comments do
          present @attachment.comments.includes(:user).asc, with: Comments::CommentEntity
        end

      end
    end
  end
end

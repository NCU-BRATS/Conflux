module V1
  class ProjectSnippetAPI < Grape::API
    resources :snippets do

      desc 'snippet create'
      post do
        @form = SnippetOperation::Create.new(current_user, @project)
        @form.process(ActionController::Parameters.new(snippet: params))
        present @form.model, with: Attachments::AttachmentEntity
      end

      route_param :snippet_id do
        before do
          @snippet ||= @project.snippets.includes(participations: :user).where(sequential_id: params[:snippet_id]).first
        end

        desc 'snippet update'
        put do
          @form = SnippetOperation::Update.new(current_user, @project, @snippet)
          @form.process(ActionController::Parameters.new(snippet: params))
          present @form.model, with: Attachments::AttachmentEntity
        end

      end

    end
  end
end

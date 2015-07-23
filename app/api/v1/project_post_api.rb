module V1
  class ProjectPostAPI < Grape::API
    resources :posts do

      desc 'post create'
      post do
        @form = PostOperation::Create.new(current_user, @project)
        @form.process(ActionController::Parameters.new(post: params))
        present @form.model, with: Attachments::AttachmentEntity
      end

      route_param :post_id do
        before do
          @post ||= @project.posts.includes(participations: :user).where(sequential_id: params[:post_id]).first
        end

        desc 'post update'
        put do
          @form = PostOperation::Update.new(current_user, @project, @post)
          @form.process(ActionController::Parameters.new(post: params))
          present @form.model, with: Attachments::AttachmentEntity
        end

      end

    end
  end
end

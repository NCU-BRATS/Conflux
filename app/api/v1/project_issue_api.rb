module V1
  class ProjectIssueAPI < Grape::API
    resources :issues do
      route_param :issue_id do
        before do
          @issue ||= @project.issues.includes(participations: :user).where(sequential_id: params[:issue_id]).first
        end

        desc 'issue show'
        get do
          present @issue, with: Issues::IssueEntity
        end
      end
    end
  end
end

module V1
  class ProjectAPI < Grape::API
    desc 'project index'
    get do
      q = Project.with_visibility_level(:public).search(params[:q])
      projects = q.result.page(params[:page]).per(params[:per])
      present projects, with: Projects::ProjectEntity
    end

    route_param :id do
      before do
        @project = Project.find_by_slug!(params[:id])
      end

      desc 'project show'
      get do
        present @project, with: Projects::ProjectEntity
      end

      mount V1::ProjectIssueAPI
    end
  end
end

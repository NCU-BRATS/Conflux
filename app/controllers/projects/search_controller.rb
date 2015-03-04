class Projects::SearchController < Projects::ApplicationController

  def index
    @search = ProjectSearch.new(search_param)
    @results = @search.search.page(params[:page]).preload(
      issue: { scope: Issue.includes(:user) }
    )
  end

  protected

  def search_param
    (params[:project_search] || params.class.new)
      .permit(:query, :type).merge({project: @project})
  end

  def model
    ProjectSearch
  end

end

class Projects::SearchController < Projects::ApplicationController

  def index
    @search = ProjectSearch.new(search_param)
    @results = @search.search.per(10).page(params[:page]).preload(
      issue: { scope: Issue.includes(:user) },
      sprint: { scope: Sprint.includes(:user) },
      attachment: { scope: Attachment.includes(:user) },
      message: { scope: Message.includes(:user, :channel) }
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

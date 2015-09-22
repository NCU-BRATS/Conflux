class Projects::SearchController < Projects::ApplicationController

  def index
    @search = ProjectSearch.new(search_param)
    @results = @search.search.per(10).page(params[:page]).preload(
      issue: { scope: Issue.includes(:user) },
      sprint: { scope: Sprint.includes(:user) },
      attachment: { scope: Attachment.with_deleted.includes(:user) },
      message: { scope: Message.includes(:user, :channel) }
    )
  end

  protected

  def search_param
    (params[:project_search] || params.class.new)
      .permit(:query, :type, :label, :status, :attachment_type, :channel).merge({project: @project})
  end

  def model
    ProjectSearch
  end

end

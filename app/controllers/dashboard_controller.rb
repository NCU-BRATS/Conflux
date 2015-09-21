class DashboardController < ApplicationController

  layout 'dashboard'

  before_action :authenticate_user!

  def show
    @q = current_user.projects.page.search( params[:q] )
    @projects = @q.result.uniq.page( params[:page] ).per( params[:per] ).limit(5)
    respond_with @projects
  end

  def events
    @events = current_user.recent_events.page( params[:page] ).per( params[:per] )
  end

  def notices
    params[:type_eq] = params[:type_eq] || 'unseal'
    @unseal_count = current_user.notices.where(state: Notice.states[:unseal]).count
    @seal_count = current_user.notices.where(state: Notice.states[:seal]).count
  end

  def projects
    @q = current_user.projects.page.search( params[:q] )
    @projects = @q.result.uniq.page( params[:page] ).per( params[:per] )
    respond_with @projects
  end

  def issues
    @issues = Issue.where('issues.user_id = ? OR issues.assignee_id = ?', current_user.id, current_user.id).includes(:user, :assignee, :labels, :project).order('id DESC')
    @q = @issues.search( params[:q] )
    @issues = @q.result.uniq.page( params[:page] ).per( params[:per] )
    respond_with @issues
  end

  def attachments
    @q = current_user.attachments.includes(:project).search( params[:q] )
    @attachments = @q.result.uniq.latest.page( params[:page] ).per( params[:per] )
    respond_with @attachments
  end

  def precious
    params[:precious] ||= "comments"
    case params[:precious]

    when "comments"
      @precious = Comment.evaluated_by(:likes, current_user)
    when "posts"
      @precious = Post.evaluated_by(:likes, current_user)
    when "snippets"
      @precious = Snippet.evaluated_by(:likes, current_user)
    when "images"
      @precious = Image.evaluated_by(:likes, current_user)
    when "others"
      @precious = OtherAttachment.evaluated_by(:likes, current_user)
    end
    @precious = @precious.page( params[:page] ).per( params[:per] )
    respond_with @precious
  end

end

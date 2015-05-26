class NoticesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_notice, except: [:index, :check, :count, :archive]

  def index
    params.reverse_merge!({q: {state_eq: Notice.states[:unseal]}})
    params[:q][:state_eq] = Notice.states[:seal] if params[:q][:state_eq] == 'seal'

    @notices = current_user.notices.includes(:author, :project).recent.limit(10).search(params[:q]).result
    respond_with @notices
  end

  def count
    @notices = current_user.notices.where(mode: Notice.modes[:unread]).count
    render plain: @notices
  end

  def read
    NoticeOperation::Read.new(current_user, @notice).process
    respond_with @notice
  end

  def seal
    NoticeOperation::Seal.new(current_user, @notice).process
    head :ok
  end

  def unseal
    NoticeOperation::Unseal.new(current_user, @notice).process
    redirect_to :back
  end

  def check
    @notices = current_user.notices.where(mode: Notice.modes[:unread])
    @notices.each do |notice|
      NoticeOperation::Read.new(current_user, notice).process
    end
    head :ok
  end

  def archive
    @notices = current_user.notices.where(state: Notice.states[:unseal])
    @notices.each do |notice|
      NoticeOperation::Seal.new(current_user, notice).process
    end
    head :ok
  end

  def link
    NoticeOperation::Seal.new(current_user, @notice).process
    target = @notice.target_json
    redirect_to redirect_url @notice, target
  end

  def set_notice
    @notice ||= Notice.find(params[:id])
  end

  protected

  def redirect_url (notice, target)
    if notice.comment?
      return redirect_url_comment notice, target
    elsif notice.attachment?
      return redirect_url_attachment notice, target
    else
      return redirect_url_other notice, target
    end
  end

  def redirect_url_comment (notice, target)
    id = target['commentable']['sequential_id'] || target['commentable']['id']
    return send("project_#{target['commentable_type'].underscore}_path", notice.project, id)
  end

  def redirect_url_attachment (notice, target)
    case target
      when Post, Snippet
        return send("project_#{notice.target_type.underscore}_path", notice.project, target['id'])
      else
        return project_attachment_path(notice.project, target['id'])
    end
  end

  def redirect_url_other (notice, target)
    id = target['sequential_id'] || target['id']
    return send("project_#{notice.target_type.underscore}_path", notice.project, id)
  end


end

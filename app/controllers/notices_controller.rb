class NoticesController < ApplicationController

  before_action :set_notice, except: [:check]

  def read
    @notice.read!
    @notice.save
    respond_with @notice
  end

  def seal
    @notice.seal!
    @notice.save
    redirect_to :back
  end

  def unseal
    @notice.unseal!
    @notice.save
    redirect_to :back
  end

  def check
    @notices = current_user.notices.where(mode: Notice.modes[:unread])
    @notices.each do |notice|
      notice.read!
      notice.save
    end
    render :nothing => true, :status => 200
  end

  def link
    @notice.seal!
    @notice.save
    target = @notice.target_json
    redirect_to redirect_url @notice, target
  end

  def set_notice
    @notice ||= Notice.find(params[:notice_id])
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
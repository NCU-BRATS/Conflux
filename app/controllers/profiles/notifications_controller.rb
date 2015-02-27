class Profiles::NotificationsController < ProfilesController

  def show
    @email_options = {mention: current_user.mention_email,
              participating: current_user.participating_email,
              watch: current_user.watch_email}
    @notification = current_user.notification
    @project_participations = current_user.project_participations
  end

  def update
    notification_type = params[:notification_type]
    saved = if notification_type == 'default'
              current_user.notification_level = params[:notification_level]
              current_user.save
            elsif notification_type == 'project'
              notification = current_user.project_participations.find(params[:notification_id])
              notification.notification_level = params[:notification_level]
              notification.save
            elsif notification_type == 'email'
              current_user.update(notification_email_params)
              current_user.save
            end
    if saved
      flash[:notice] = "成功儲存通知設定"
    else
      flash[:notice] = "儲存通知失敗"
    end
  end

  private

  def notification_email_params
    params.require(:option).permit(:mention_email, :participating_email, :watch_email)
  end

end

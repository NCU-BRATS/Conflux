class Profiles::NotificationsController < ProfilesController

  def show
    @email_options = {mention: current_user.mention_email_enabled,
              participating: current_user.participating_email_enabled,
              watch: current_user.watch_email_enabled}
    @notification = current_user.notification
    @project_participations = current_user.project_participations
  end

  def update
    notification_type = params[:notification_type]
    saved = case notification_type
            when 'default'
              current_user.notification_level = params[:notification_level]
              current_user.save
            when 'project'
              notification = current_user.project_participations.find(params[:notification_id])
              notification.notification_level = params[:notification_level]
              notification.save
            when 'email'
              current_user.update(notification_email_params)
              current_user.save
            end
    if saved
      flash[:notice] = t('flash.actions.update.notice', resource_name: t('profile.notification.notification_settings'))
    else
      flash[:alert] = t('flash.actions.update.alert', resource_name: t('profile.notification.notification_settings'))
    end
  end

  private

  def notification_email_params
    params.require(:option).permit(:mention_email_enabled, :participating_email_enabled, :watch_email_enabled)
  end

end

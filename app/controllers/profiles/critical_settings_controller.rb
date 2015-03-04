class Profiles::CriticalSettingsController < Devise::RegistrationsController
  layout 'profile'

  protected

  def after_update_path_for(resource)
    profile_critical_settings_path
  end
end

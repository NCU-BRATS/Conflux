class Profiles::RegistrationsController < Devise::RegistrationsController
  layout 'profile'

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << [:title, :phone, :url, :github, :linkedin, :facebook, :twitter]
  end

  def after_update_path_for(resource)
    profile_path
  end
end

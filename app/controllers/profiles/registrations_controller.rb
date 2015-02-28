class Profiles::RegistrationsController < Devise::RegistrationsController
  layout 'profile'

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << [:name, :title]
  end
end

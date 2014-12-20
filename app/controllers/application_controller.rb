class ApplicationController < ActionController::Base
  include Pundit

  responders :flash, :http_cache
  respond_to :html, :json, :js

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << [:name, :title]
    end
end

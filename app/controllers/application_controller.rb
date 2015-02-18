class ApplicationController < ActionController::Base

  include AuthorizationConcern

  layout 'default'

  responders :flash, :http_cache, :js_default
  respond_to :html, :json, :js

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :preload_sti_descendants, if: "Rails.env.development?"
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :title]
  end

  def preload_sti_descendants
    [Post, Snippet, Image, OtherAttachment]
  end

end

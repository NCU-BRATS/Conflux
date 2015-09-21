class ApplicationController < ActionController::Base
  include AuthorizationConcern

  layout 'default'

  responders :flash, :js_default
  respond_to :html, :json, :js

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :preload_sti_descendants
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :logging_access
  around_action :index_in_sidekiq, if: :production?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :title]
  end

  def preload_sti_descendants
    [Post, Snippet, Image, OtherAttachment]
  end

  def index_in_sidekiq
    Chewy.strategy(:sidekiq) do
      yield
    end
  end

  def production?
    Rails.env.production?
  end

  def logging_access
    param = {}
    param[:user_id] = current_user ? current_user.id : nil
    param[:session_id] = request.session.id
    param[:action] = request.params[:action]
    param[:controller] = request.params[:controller]
    param[:path] = request.original_url
    param[:format] = request.format.to_s
    param[:remote_ip] = request.remote_ip
    param[:params] = params.as_json
    param[:headers] = request.headers.to_h.slice(
      'SERVER_ADDR',
      'SERVER_NAME',
      'HTTP_CONNECTION',
      'HTTP_CACHE_CONTROL',
      'HTTP_USER_AGENT',
      'HTTP_REFERER',
    )
    if param[:params]['user']
      param[:params]['user']['password'] = '*' if param[:params]['user']['password']
      param[:params]['user']['password_confirmation'] = '*' if param[:params]['user']['password_confirmation']
      param[:params]['user']['current_password'] = '*' if param[:params]['user']['current_password']
    end
    AccessLoggerJob.perform_later(param)
  end

end

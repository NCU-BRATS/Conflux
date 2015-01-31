module AuthorizationConcern
  extend ActiveSupport::Concern

  class ResourceMethodNotOverridedError < StandardError; end

  included do
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  end

  protected

  def authorize_resourse
    authorize (params[:id] ? resource : model)
  end

  def resource
    raise ResourceMethodNotOverridedError.new('This method should be overrided in controller to prepare the resource for Pundit.')
  end

  def policy_target
    @model ||= controller_name.classify.constantize
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:alert] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
    redirect_to(request.referrer || root_path)
  end

end

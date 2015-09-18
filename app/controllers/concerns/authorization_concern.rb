module AuthorizationConcern
  extend ActiveSupport::Concern
  include ModelGuessableConcern

  class ResourceMethodNotOverridedError < StandardError; end

  included do
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  end

  protected

  def authorize_resourse
    begin
      authorize (params[:id] ? resource : model)
    rescue
      raise ActiveRecord::RecordNotFound
    end
  end

  def resource
    raise ResourceMethodNotOverridedError.new('This method should be overrided in controller to prepare the resource for Pundit.')
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:alert] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
    redirect_to(request.referrer || root_path)
  end

end

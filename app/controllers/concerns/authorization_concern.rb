module AuthorizationConcern
  class ResourceMethodNotOverridedError < StandardError; end

  extend ActiveSupport::Concern

  include Pundit

  protected

  def authorize_resourse
    case params[:action]
    when 'index', 'create', 'new'
      authorize policy_target
    else
      authorize resource
    end
  end

  def resource
    raise ResourceMethodNotOverridedError.new('This method should be overrided in controller to prepare the resource for Pundit.')
  end

  def policy_target
    @model ||= controller_name.classify.constantize
  end

end

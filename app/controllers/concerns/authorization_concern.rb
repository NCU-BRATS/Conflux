module AuthorizationConcern
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
    policy_target
  end

  def policy_target
    @model ||= controller_name.classify.constantize
  end

end

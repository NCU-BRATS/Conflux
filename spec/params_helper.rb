module ParamsHelper
  def new_param(param = {})
    ActionController::Parameters.new(param)
  end
end

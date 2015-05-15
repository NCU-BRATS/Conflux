class BaseOperation < Trailblazer::Operation
  include CRUD
  include CRUD::ActiveModel

  def to_model
    @model
  end

  private

  def instantiate_model(params)
    return params[:model] if params[:model]
    super
  end
end

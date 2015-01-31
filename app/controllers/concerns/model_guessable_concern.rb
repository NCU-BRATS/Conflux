module ModelGuessableConcern
  extend ActiveSupport::Concern

  included do
    helper_method :model, :model_sym, :model_human_name

    protected

    def model
      @model ||= controller_name.classify.constantize
    end

    def model_sym
      @model_sym ||= model.name.demodulize.underscore.to_sym
    end

    def model_human_name
      model.model_name.human
    end
  end

end

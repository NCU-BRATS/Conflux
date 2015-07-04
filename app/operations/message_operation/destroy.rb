module MessageOperation
  class Destroy < BaseForm

    def initialize(current_user, message)
      @current_user = current_user
      super(message)
    end

    def process
      @model.destroy
    end

  end
end

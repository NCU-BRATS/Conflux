module MessageOperation
  class Destroy < BaseForm

    def initialize(current_user, channel)
      @current_user = current_user
      super(channel)
    end

    def process
      @model.destroy
    end

  end
end

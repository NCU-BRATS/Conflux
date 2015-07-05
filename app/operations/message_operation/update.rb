module MessageOperation
  class Update < BaseForm

    def initialize(current_user, message)
      @current_user = current_user
      super(message)
    end

    def process(params)
      validate(message_params(params)) && save
    end

  end
end

module MessageOperation
  class Update < BaseForm

    def initialize(current_user, channel)
      @current_user = current_user
      super(channel)
    end

    def process(params)
      validate(params[:message]) && save
    end

  end
end

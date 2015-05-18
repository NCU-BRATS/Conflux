module ProjectOperation
  class Update < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      super(project)
    end

    def process(params)
      validate(params[:project]) && save
    end

  end
end

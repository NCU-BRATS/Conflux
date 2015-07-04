module ProjectOperation
  class Update < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      super(project)
    end

    def process(params)
      validate(project_params(params)) && save
    end

  end
end

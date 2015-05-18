module SprintOperation
  class Update < BaseForm

    def initialize(current_user, project, sprint)
      @current_user = current_user
      @project      = project

      super({sprint: sprint})
    end

    def process(params)
      validate(params[:sprint]) && save
    end

  end
end

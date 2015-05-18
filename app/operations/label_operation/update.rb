module LabelOperation
  class Update < BaseForm

    def initialize(current_user, project, label)
      @current_user = current_user
      @project      = project
      super(label)
    end

    def process(params)
      validate(params[:label]) && save
    end

  end
end

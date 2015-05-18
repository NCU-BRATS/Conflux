module LabelOperation
  class Destroy < BaseForm

    def initialize(current_user, project, label)
      @current_user = current_user
      @project      = project
      super(label)
    end

    def process
      @model.destroy
    end

  end
end

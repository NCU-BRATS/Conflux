module ProjectOperation
  class Create < BaseForm

    def initialize(current_user)
      @current_user = current_user
      super(Project.new)
    end

    def process(params)
      if validate(project_params(params)) && sync
        @model.members << @current_user
        @model.save
      end
    end

  end
end

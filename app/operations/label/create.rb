class Label < ActiveRecord::Base
  class Create < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      super(Label.new)
    end

    def process(params)
      if validate(params[:label]) && sync
        @model.project = @project
        @model.save
      end
    end

  end
end

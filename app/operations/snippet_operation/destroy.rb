module SnippetOperation
  class Destroy < BaseForm

    def initialize(current_user, project, snippet)
      @current_user = current_user
      @project      = project
      super(snippet)
    end

    def process
      @model.destroy
    end

  end
end

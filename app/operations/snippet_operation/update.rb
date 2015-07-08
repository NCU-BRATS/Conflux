module SnippetOperation
  class Update < BaseForm

    def initialize(current_user, project, snippet)
      @current_user = current_user
      @project      = project
      super(snippet)
    end

    def process(params)
      validate(snippet_params(params)) && save
    end

  end
end

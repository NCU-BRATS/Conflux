module PostOperation
  class Update < BaseForm

    def initialize(current_user, project, post)
      @current_user = current_user
      @project      = project
      super(post)
    end

    def process(params)
      validate(post_params(params)) && save
    end

  end
end

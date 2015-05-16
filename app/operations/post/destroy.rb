class Post < Attachment
  class Destroy < BaseForm

    def initialize(current_user, project, post)
      @current_user = current_user
      @project      = project
      super(post)
    end

    def process
      @model.destroy
    end

  end
end

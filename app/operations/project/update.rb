class Project < ActiveRecord::Base
  class Update < BaseOperation

    model Project, :update

    contract do
      property :name,             validates: {presence: true}
      property :visibility_level, validates: {presence: true}
      property :description
    end

    def process(params)
      validate(project_params(params)) do |f|
        f.save
      end
    end

    private

    def project_params(params)
      params.require(:project).permit(:name, :description, :visibility_level)
    end
  end
end

module ProjectRoleOperation
  class BaseForm < Reform::Form

    model :project_role

    property :name

    validates :name, presence: true

    private

    def project_role_params(params)
      params.require(:project_role)
    end

  end
end

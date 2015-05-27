module ProjectRoleOperation
  class BaseForm < Reform::Form

    model :project_role

    property :name

    validates :name, presence: true

    private

    def mention_service
      MentionService.new
    end

  end
end

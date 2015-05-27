module ProjectParticipationOperation
  class BaseForm < Reform::Form

    model :project_participation

    property :project_role_id

    private

    def mention_service
      MentionService.new
    end

  end
end

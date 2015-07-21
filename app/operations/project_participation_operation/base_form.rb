module ProjectParticipationOperation
  class BaseForm < Reform::Form

    model :project_participation

    property :project_role_id

    private

    def project_participation_params(params)
      params.require(:project_participation)
    end

  end
end

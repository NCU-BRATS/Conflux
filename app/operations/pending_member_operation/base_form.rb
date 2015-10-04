module PendingMemberOperation
  class BaseForm < Reform::Form

    model :pending_member

    private

    def pending_member_params(params)
      params.require(:pending_member)
    end

  end
end

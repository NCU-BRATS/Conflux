module ParticipationOperation
  class Create
    def initialize(user, participable)
      @user         = user
      @participable = participable
    end

    def process
      if !@participable.participations.exists?(user_id: @user.id)
        @participable.participations.create(user: @user)
        true
      else
        false
      end
    end
  end
end

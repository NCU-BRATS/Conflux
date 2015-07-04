require 'rails_helper'

RSpec.describe ParticipationOperation::Create do

  include_context 'issue sprint with project members and labels'

  describe '#process' do
    context 'when success' do

      it 'create the participation' do
        ParticipationOperation::Create.new(@members[0], @issue).process
        expect(@issue.participations.exists?(user_id: @members[0].id)).to be true
      end

    end
  end
end

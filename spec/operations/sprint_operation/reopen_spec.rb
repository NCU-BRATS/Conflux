require 'rails_helper'

RSpec.describe SprintOperation::Reopen do

  include_context 'issue sprint with project members and labels'

  before(:example) { @sprint.close }

  describe '#process' do
    context 'when success' do

      let(:success) { SprintOperation::Reopen.new(@members[0], @project, @sprint).process }

      it 'reopens the sprint' do
        success
        expect( @sprint.open? ).to be true
      end

      it 'fires corresponding event' do
        expect { success }.to broadcast(:on_sprint_reopened)
      end

    end
  end
end

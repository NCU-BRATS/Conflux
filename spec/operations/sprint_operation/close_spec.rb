require 'rails_helper'

RSpec.describe SprintOperation::Close do

  include_context 'issue sprint with project members and labels'

  describe '#process' do
    context 'when success' do
      let(:success) { SprintOperation::Close.new(@members[0], @project, @sprint).process }

      it 'closes the sprint' do
        success
        expect(@sprint.closed?).to be true
      end

      it 'fires corresponding event' do
        expect { success }.to broadcast(:on_sprint_closed)
      end
    end
  end
end

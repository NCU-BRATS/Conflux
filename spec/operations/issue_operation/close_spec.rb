require 'rails_helper'

RSpec.describe IssueOperation::Close do

  include_context 'issue sprint with project members and labels'

  describe '#process' do
    context 'when success' do

      let(:success) { IssueOperation::Close.new(@members[0], @project, @issue).process }

      it 'closes the issue' do
        success
        expect( @issue.closed? ).to be true
      end

      it 'fires corresponding event' do
        expect { success }.to broadcast(:on_issue_closed)
      end

    end
  end
end

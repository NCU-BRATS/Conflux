require 'rails_helper'

RSpec.describe IssueOperation::Reopen do

  include_context 'issue sprint with project members and labels'

  before(:example) { @issue.close }

  describe '#process' do
    context 'when success' do
      let(:success) { IssueOperation::Reopen.new(@members[0], @project, @issue).process }

      it 'reopen the issue' do
        success
        expect(@issue.open?).to be true
      end

      it 'fires corresponding event' do
        expect { success }.to broadcast(:on_issue_reopened)
      end
    end
  end
end

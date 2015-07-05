require 'rails_helper'

RSpec.describe IssueOperation::Update do

  include_context 'issue sprint with project members and labels'

  subject { IssueOperation::Update.new(@members[0], @project, @issue) }

  describe '#process' do

    context 'when given valid params' do

      it 'changes the title' do
        subject.process( new_param( { issue: { title: 'name_changed' } } ) )
        expect( @issue.title ).to eq 'name_changed'
      end

      it 'changes the begin_at' do
        subject.process( new_param( { issue: { begin_at: '2015-07-01' } } ) )
        expect( @issue.begin_at.strftime('%F') ).to eq '2015-07-01'
      end

      it 'changes the due_at' do
        subject.process( new_param( { issue: { due_at: '2015-07-02' } } ) )
        expect( @issue.due_at.strftime('%F') ).to eq '2015-07-02'
      end

      it 'changes the status' do
        subject.process( new_param( { issue: { status: 'closed' } } ) )
        expect( @issue.status ).to eq 'closed'
      end

      it 'changes the assignee and add to participations' do
        subject.process( new_param( { issue: { assignee_id: @members[2].id } } ) )
        expect( @issue.assignee ).to eq @members[2]
        expect( @issue.participations.find {|p| p.user_id == @members[2].id} ).not_to be nil
      end

      it 'changes the sprint' do
        subject.process( new_param( { issue: { sprint_id: @sprint.id } } ) )
        expect( @issue.sprint ).to eq @sprint
      end

      it 'changes the labels' do
        subject.process( new_param( { issue: { label_ids: [ @label.id ] } } ) )
        expect( @issue.labels.include? @label ).to be true
      end

    end

    context 'when given incorrect params' do
      it 'raise ActionController::ParameterMissing' do
        expect{ subject.process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end

  end
end

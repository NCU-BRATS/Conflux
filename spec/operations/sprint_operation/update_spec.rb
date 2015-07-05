require 'rails_helper'

RSpec.describe SprintOperation::Update do

  include_context 'issue sprint with project members and labels'

  subject { SprintOperation::Update.new(@members[0], @project, @sprint) }

  describe '#process' do

    context 'when given valid params' do

      it 'changes the title' do
        subject.process( new_param( { sprint: { title: 'name_changed' } } ) )
        expect( @sprint.title ).to eq 'name_changed'
      end

      it 'changes the begin_at' do
        subject.process( new_param( { sprint: { begin_at: '2015-07-01' } } ) )
        expect( @sprint.begin_at.strftime('%F') ).to eq '2015-07-01'
      end

      it 'changes the due_at' do
        subject.process( new_param( { sprint: { due_at: '2015-07-02' } } ) )
        expect( @sprint.due_at.strftime('%F') ).to eq '2015-07-02'
      end

      it 'changes the status' do
        subject.process( new_param( { sprint: { status: 'closed' } } ) )
        expect( @sprint.status ).to eq 'closed'
      end

      it 'changes the issues' do
        subject.process( new_param( { sprint: { issue_ids: [ @issue.id ] } } ) )
        expect( @sprint.issues.include? @issue ).to be true
      end

    end

    context 'when given incorrect params' do
      it 'raise ActionController::ParameterMissing' do
        expect{ subject.process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end

  end
end

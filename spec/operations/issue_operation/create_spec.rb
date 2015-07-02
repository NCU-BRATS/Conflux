require 'rails_helper'

RSpec.describe IssueOperation::Create do
  include_context 'project with members'

  describe '#process' do

    context 'when given valid params' do
      before(:context) do
         @params = new_param({ issue:{
          title: 'testtitle',
          content: 'testcontent',
          assignee_id: @members[1].id
        }})

        @operation = IssueOperation::Create.new(@members[0], @project)
        @operation.process(@params)
      end

      it 'creates a comment with the given project, user, title and other attributes' do
        condiction = [
          @operation.model.project == @project,
          @operation.model.user    == @members[0],
          @operation.model.title   == 'testtitle',
          @operation.model.assignee == @members[1]
        ]
        expect(condiction).to all( be true )
      end

      it 'creates a comment as content' do
        expect(@operation.model.comments.first.content).to eq('testcontent')
      end

      it 'adds creator to participation' do
        expect(@operation.model.participations.find {|p| p.user_id == @members[0].id}).not_to be nil
      end

      it 'adds assignee to participation' do
        expect(@operation.model.participations.find {|p| p.user_id == @members[1].id}).not_to be nil
      end

      it 'fires corresponding event' do
        operation = IssueOperation::Create.new(@members[0], @project)
        expect{operation.process(@params)}.to broadcast(:on_issue_created)
      end
    end

    context 'when given incorrect params'  do
      it 'raise ActionController::ParameterMissing' do
        expect{IssueOperation::Create.new(@members[0], @project).process(new_param)}.to raise_error ActionController::ParameterMissing
      end
    end
  end
end

require 'rails_helper'

RSpec.describe IssueOperation::Create do

  include_context 'project with members and sprints'

  describe '#process' do

    context 'when given valid params' do

      before(:context) do
         @params = new_param({ issue:{
          title: 'testtitle',
          content: 'testcontent',
          sprint_id: @sprints[0].id,
          status: @sprints[0].statuses[0]['id'],
          assignee_id: @members[1].id
        }})

        @operation = IssueOperation::Create.new(@members[0], @project)
        @operation.process(@params)
      end

      it 'creates a record in database' do
        expect( @operation.model.persisted? ).to be true
      end

      it 'creates an issue with the given project, user, title and other attributes' do
        conditions = [
          @operation.model.project == @project,
          @operation.model.sprint  == @sprints[0],
          @operation.model.status  == @sprints[0].statuses[0]['id'].to_s,
          @operation.model.user    == @members[0],
          @operation.model.title   == 'testtitle',
          @operation.model.assignee == @members[1]
        ]
        expect( conditions ).to all( be true )
      end

      it 'adds creator to participation' do
        expect( @operation.model.participations.find {|p| p.user_id == @members[0].id} ).not_to be nil
      end

      it 'adds assignee to participation' do
        expect( @operation.model.participations.find {|p| p.user_id == @members[1].id} ).not_to be nil
      end

      it 'fires corresponding event' do
        operation = IssueOperation::Create.new(@members[0], @project)
        expect{ operation.process(@params) }.to broadcast(:on_issue_created)
      end
    end

    context 'when given incorrect params'  do
      it 'doesnt create record in database' do
        @params = new_param({ issue:{
                                title: 'testtitle',
                                content: 'testcontent',
                                sprint_id: @sprints[0].id,
                                status: -1,
                                assignee_id: @members[1].id
                            }})

        @operation = IssueOperation::Create.new(@members[0], @project)
        @operation.process(@params)
        expect( @operation.model.persisted? ).to be false
      end
      it 'raise ActionController::ParameterMissing' do
        expect{ IssueOperation::Create.new(@members[0], @project).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end

  end
end

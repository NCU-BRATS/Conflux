require 'rails_helper'

RSpec.describe SprintOperation::Create do

  include_context 'project with members'

  describe '#process' do

    context 'when given valid params' do

      before(:context) do
         @params = new_param({ sprint:{
          title: 'testtitle',
          content: 'testcontent',
          begin_at: '2015-07-01',
          due_at: '2015-07-02'
        }})

        @operation = SprintOperation::Create.new(@members[0], @project)
        @operation.process(@params)
      end

      it 'creates a record in database' do
        expect( @operation.model.persisted? ).to be true
      end

      it 'creates an sprint with the given project, user, title and other attributes' do
        conditions = [
          @operation.model.project == @project,
          @operation.model.user    == @members[0],
          @operation.model.title   == 'testtitle',
          @operation.model.begin_at.strftime('%F') == '2015-07-01',
          @operation.model.due_at.strftime('%F')   == '2015-07-02'
        ]
        expect( conditions ).to all( be true )
      end

      it 'creates a comment as content' do
        expect( @operation.model.comments.first.content ).to eq('testcontent')
      end

      it 'adds creator to participation' do
        expect( @operation.model.participations.find {|p| p.user_id == @members[0].id} ).not_to be nil
      end

      it 'fires corresponding event' do
        operation = SprintOperation::Create.new(@members[0], @project)
        expect{ operation.process(@params) }.to broadcast(:on_sprint_created)
      end

    end

    context 'when given incorrect params'  do
      it 'raise ActionController::ParameterMissing' do
        expect{ SprintOperation::Create.new(@members[0], @project).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end

  end
end

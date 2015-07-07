require 'rails_helper'

RSpec.describe PostOperation::Create do
  include_context 'project with members'

  describe '#process' do

    context 'when given valid params' do
      before(:context) do
        @params = new_param({ post:{
          name: 'testtitle',
          content: 'testcontent'
        }})

        @operation = PostOperation::Create.new(@members[0], @project)
        @operation.process(@params)
      end

      it 'creates an post with the given project, user, name and content' do
        condition = [
          @operation.model.project == @project,
          @operation.model.user    == @members[0],
          @operation.model.name    == 'testtitle',
          @operation.model.content == 'testcontent'
        ]
        expect(condition).to all( be true )
      end

      it 'adds creator to participation' do
        expect(@operation.model.participations.find {|p| p.user_id == @members[0].id}).not_to be nil
      end

      it 'fires corresponding event' do
        operation = PostOperation::Create.new(@members[0], @project)
        expect{operation.process(@params)}.to broadcast(:on_attachment_created)
      end
    end

    context 'when given incorrect params'  do
      it 'raise ActionController::ParameterMissing' do
        expect{PostOperation::Create.new(@members[0], @project).process(new_param(post: {}))}.to raise_error ActionController::ParameterMissing
      end
    end
  end
end

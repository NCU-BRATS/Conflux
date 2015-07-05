require 'rails_helper'

RSpec.describe PollOperation::Create do

  include_context 'project with members'

  describe '#process' do

    context 'when given valid params' do

      before(:context) do
         @params = new_param({ poll:{
          title: 'test',
          allow_multiple_choice: 1,
          content: 'test content',
          options_attributes: { '0': { 'title': 'new_option' } }
        }})

        @operation = PollOperation::Create.new(@members[0], @project)
        @operation.process(@params)
      end

      it 'creates a record in database' do
        expect( @operation.model.persisted? ).to be true
      end

      it 'creates a poll with the given project, user, title and allow_multiple_choice' do
        conditions = [
          @operation.model.project == @project,
          @operation.model.user    == @members[0],
          @operation.model.title   == 'test',
          @operation.model.allow_multiple_choice == true
        ]
        expect( conditions ).to all( be true )
      end

      it 'creates a comment as content' do
        expect( @operation.model.comments.first.content ).to eq('test content')
      end

      it 'adds creator to participation' do
        expect( @operation.model.participations.find {|p| p.user_id == @members[0].id} ).not_to be nil
      end

      it 'fires on_poll_created event' do
        operation = PollOperation::Create.new(@members[0], @project)
        expect{ operation.process(@params) }.to broadcast(:on_poll_created)
      end

    end

    context 'when given params without poll' do
      it 'raise ActionController::ParameterMissing' do
        expect{ PollOperation::Create.new(@members[0], @project).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end

  end
end

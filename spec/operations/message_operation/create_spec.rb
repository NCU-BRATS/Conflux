require 'rails_helper'

RSpec.describe MessageOperation::Create do

  include_context 'channel with project and members'

  describe '#process' do

    context 'when given valid params' do

      before(:example) do
        @params = new_param ({
          message: {
            content: 'content'
          }
        })
        @operation = MessageOperation::Create.new( @members[0], @channel )
        @operation.process( @params )
      end

      it 'creates a record in database' do
        expect( @operation.model.persisted? ).to be true
      end

      it 'creates a message with the given channel, user and other attributes' do
        conditions = [
          @operation.model.content == 'content',
          @operation.model.channel == @channel,
          @operation.model.user    == @members[0]
        ]
        expect( conditions ).to all( be true )
      end

    end

    context 'when given incorrect params' do
      it 'raise ActionController::ParameterMissing' do
        expect{ MessageOperation::Create.new( @members[1], @channel ).process( new_param ) }.to raise_error ActionController::ParameterMissing
      end
    end

  end

end

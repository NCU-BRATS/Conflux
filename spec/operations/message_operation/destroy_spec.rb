require 'rails_helper'

RSpec.describe MessageOperation::Destroy do

  include_context 'message with its channel project and member'

  subject { MessageOperation::Destroy.new(@members[0], @message) }

  describe '#process' do
    context 'when called' do

      it 'destroys the message' do
        subject.process
        expect( @message.destroyed? ).to be true
      end

    end

  end
end

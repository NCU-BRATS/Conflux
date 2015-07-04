require 'rails_helper'

RSpec.describe NoticeOperation::Unseal do

  include_context 'notice'

  describe '#process' do
    context 'when success' do

      it 'unseal the notice' do
        NoticeOperation::Unseal.new(@members[0], @notice).process
        expect(@notice.unseal?).to be true
      end

    end
  end
end

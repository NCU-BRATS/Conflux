require 'rails_helper'

RSpec.describe NoticeOperation::Read do

  include_context 'notice'

  describe '#process' do
    context 'when success' do

      it 'reads the notice' do
        NoticeOperation::Read.new(@members[0], @notice).process
        expect( @notice.read? ).to be true
      end

    end
  end
end

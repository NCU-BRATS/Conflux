require 'rails_helper'

RSpec.describe NoticeOperation::Seal do

  include_context 'notice'

  describe '#process' do
    context 'when success' do

      it 'seals the notice' do
        NoticeOperation::Seal.new(@members[0], @notice).process
        conditions = [
            @notice.read? == true,
            @notice.seal? == true
        ]
        expect( conditions ).to all( be true )
      end

    end
  end
end

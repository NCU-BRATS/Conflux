require 'rails_helper'

RSpec.describe NoticeOperation::Seal do

  include_context 'notice'

  describe '#process' do
    context 'when success' do

      it 'seal the notice' do
        NoticeOperation::Seal.new(@members[0], @notice).process
        condiction = [
            @notice.read? == true,
            @notice.seal? == true
        ]
        expect(condiction).to all( be true )
      end

    end
  end
end

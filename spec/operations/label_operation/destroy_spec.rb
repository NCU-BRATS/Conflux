require 'rails_helper'

RSpec.describe LabelOperation::Destroy do

  include_context 'label with color title project and member'

  subject { LabelOperation::Destroy.new(@members[0], @project, @label) }

  describe '#process' do
    context 'when called' do

      it 'destroys the label' do
        subject.process
        expect( @label.destroyed? ).to be true
      end

    end
  end
end
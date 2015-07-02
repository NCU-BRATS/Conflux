require 'rails_helper'

RSpec.describe LabelOperation::Update do
  include_context 'label with color title project and member'

  subject { LabelOperation::Update.new(@members[0], @project, @label) }

  describe '#process' do
    context 'when given valid params' do

      it 'change the title' do
        subject.process(new_param({ label: {title: 'NewTitle'} }))
        expect(@label.title).to eq 'NewTitle'
      end

      it 'change the color' do
        subject.process(new_param({ label: {color: '#D9534F'} }))
        expect(@label.color).to eq '#D9534F'
      end

    end

    context 'when given params without label' do
      it 'raise ActionController::ParameterMissing' do
        expect{subject.process(new_param)}.to raise_error ActionController::ParameterMissing
      end
    end
  end
end

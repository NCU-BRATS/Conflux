require 'rails_helper'

RSpec.describe LabelOperation::Create do
  include_context 'project with members'

  describe '#process' do
    context 'when given valid params' do
      before(:context) do
        @params = new_param({ label:{
                                title: 'test',
                                color: '#428BCA'
                            }})

        @operation = LabelOperation::Create.new(@members[0], @project)
        @operation.process(@params)
      end

      it 'create a label with the given project, title and color' do
        condiction = [
            @operation.model.project == @project,
            @operation.model.title   == 'test',
            @operation.model.color == '#428BCA'
        ]
        expect(condiction).to all( be true )
      end
    end

    context 'when given params without label' do
      it 'raise ActionController::ParameterMissing' do
        expect{ LabelOperation::Create.new(@members[0], @project).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end
  end
end

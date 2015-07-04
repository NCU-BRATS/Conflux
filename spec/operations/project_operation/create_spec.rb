require 'rails_helper'

RSpec.describe ProjectOperation::Create do

  describe '#process' do
    context 'when given valid params' do
      before(:context) do
        @params = new_param({ project:{
                                name: 'test'
                            }})
        @user = FactoryGirl.create(:user)

        @operation = ProjectOperation::Create.new(@user)
        @operation.process(@params)
      end

      it 'create a project with a given name' do
        condiction = [
            @operation.model.name == 'test',
            @operation.model.has_member?(@user) == true
        ]
        expect(condiction).to all( be true )
      end
    end

    context 'when given params without project' do
      it 'raise ActionController::ParameterMissing' do
        expect{ ProjectOperation::Create.new(@user).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end
  end
end
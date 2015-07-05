require 'rails_helper'

RSpec.describe ProjectOperation::Update do

  include_context 'project with members'

  subject { ProjectOperation::Update.new(@members[0], @project) }

  describe '#process' do

    context 'when given valid params' do
      it 'changes the name' do
        subject.process(new_param({ project: { name: 'NewName' } }))
        expect(@project.name).to eq 'NewName'
      end
    end

    context 'when given params without project' do
      it 'raise ActionController::ParameterMissing' do
        expect{subject.process(new_param)}.to raise_error ActionController::ParameterMissing
      end
    end

  end
end
require 'rails_helper'

RSpec.describe ProjectRoleOperation::Update do

  include_context 'project with members'

  before(:example) do
    @role = ProjectRole.create
    @role.name = 'test'
    @role.project_id = @project.id
    @role.save
    @opeartion = ProjectRoleOperation::Update.new(@members[0],@project,@role)
  end
  
  describe '#process'  do

    context 'given a valid params' do

      it 'update the name' do
        @opeartion.process(new_param({ project_role:{ name: 'new_name', project_id: @project.id}}))
        expect(@role.name).to eq 'new_name'
      end
    end

    context 'given a params wothout project_role' do
      it 'raise ActionController::ParameterMissing' do
        expect{ @opeartion.process(new_param)}.to raise_error ActionController::ParameterMissing
      end
    end
   
  end

end
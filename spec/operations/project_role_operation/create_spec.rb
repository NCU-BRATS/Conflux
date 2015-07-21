require 'rails_helper'

RSpec.describe ProjectRoleOperation::Create do

  include_context 'project with members'

  
  describe '#process'  do

    context 'when given valid params' do

      before(:context) do
        @params = new_param({ project_role:{ name: 'test', project_id: @project.id}})
        @operation = ProjectRoleOperation::Create.new(@members[0],@project) 
        @operation.process(@params)
      end

      it 'creates a record in database' do
        expect( @operation.model.persisted? ).to be true
      end

      it 'create a new project_role' do 
        conditions = [
            @operation.model.name == 'test',
            @operation.model.project_id == @project.id
        ]
        expect( conditions ).to all( be true )
      end

    end

    context 'when given params without project_role ' do
      it 'raise ActionController::ParameterMissing' do
        expect{ ProjectRoleOperation::Create.new(@members[0],@project).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end
   
  end

end
require 'rails_helper'

RSpec.describe ProjectParticipationOperation::Create do

  include_context 'project with members'
  
  describe '#process'  do

    context 'when given valid params' do

      before(:context) do
        @user = User.new
        @user.name = 'new_member'
        @user.save(validate: false)

        @params = new_param({ project_participation: { user_id: @user.id, project_id: @project.id}})
        @operation = ProjectParticipationOperation::Create.new(@user,@project) 
        @operation.process(@params)
      end

      it 'creates a record in database' do
        expect( @operation.model.persisted? ).to be true
      end

      it 'add a new data with project and user in users_projects' do 
        conditions = [
            @operation.model.user_id == @user.id,
            @operation.model.project_id == @project.id
        ]
        expect( conditions ).to all( be true )
      end

      it 'fire an event on project_participation created ' do
        expect{@operation.process(@params)}.to broadcast(:on_project_participation_created)
      end

    end

    context 'when given params without project_participation ' do
      it 'raise ActionController::ParameterMissing' do
        expect{ ProjectParticipationOperation::Create.new(@user,@project).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end
   
  end

end
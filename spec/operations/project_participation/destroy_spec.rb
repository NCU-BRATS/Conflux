require 'rails_helper'

RSpec.describe ProjectParticipationOperation::Destroy do
  
  describe '#process'  do

    context 'when number of the members of project is greater than 1' do

      include_context 'project with members'

      before(:context) do
        @operation = ProjectParticipationOperation::Destroy.new(@members[0],@project,@project.project_participations.find{ |p| p.user_id == @members[0].id}) 
        @operation.process
      end

      it 'delete the member of project' do
        expect( @operation.model.destroyed? ).to be true
      end


      it 'fire an event on project_participation deleted ' do
        expect{@operation.process}.to broadcast(:on_project_participation_deleted)
      end

    end

    context 'when number of the members of project is 1' do

      before(:context) do
        @project = FactoryGirl.create(:project)
        @user = FactoryGirl.create(:user)

        @params = new_param({ project_participation: { user_id: @user.id, project_id: @project.id}})
        @operation = ProjectParticipationOperation::Create.new(@user,@project) 
        @operation.process(@params)

        @operation = ProjectParticipationOperation::Destroy.new(@user,@project,@project.project_participations.find{ |p| p.user_id == @user.id}) 
        @operation.process
      end

      it 'does not delete the member' do
        expect( @operation.model.destroyed? ).to be false
      end
    end
   
  end

end
require 'rails_helper'

RSpec.describe ProjectParticipationOperation::Update do

  include_context 'project with members'
  
  describe '#process'  do

    context 'when given a valid params' do

      before(:context) do

        @role = ProjectRole.new
        @role.name = 'test'
        @role.project_id = @project.id
        @role.save

        @operation = ProjectParticipationOperation::Update.new(@members[0],@project,@project.project_participations.find{ |p| p.user_id == @members[0].id}) 
        @operation.process(new_param({project_participation: { project_role_id: @role.id }}))
      end

      it 'change change project_role_id' do

        expect(@project.project_participations.find{ |p| p.user_id == @members[0].id}.project_role_id).to equal @role.id
      end

    end

    context 'when given params without project_participation ' do
      it 'raise ActionController::ParameterMissing' do
        expect{ ProjectParticipationOperation::Update.new(@members[0],@project,@project.project_participations.find{ |p| p.user_id == @members[0].id}).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end
    
   
  end

end
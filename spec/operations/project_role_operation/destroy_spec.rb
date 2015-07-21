require 'rails_helper'

RSpec.describe ProjectRoleOperation::Create do

  include_context 'project with members'

  before(:example) do
    @role = ProjectRole.create
    @role.name = 'test'
    @role.project_id = @project.id
    @role.save
  end

  subject { ProjectRoleOperation::Destroy.new(@members[0],@project,@role) }
  
  describe '#process'  do

    context 'when called' do
      it 'destroy the role' do
        subject.process 
        expect( @role.destroyed? ).to be true
      end
    end
   
  end

end
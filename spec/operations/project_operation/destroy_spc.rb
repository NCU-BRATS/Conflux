require 'rails_helper'

RSpec.describe ProjectOperation::Destroy do

  include_context 'project with members'

  subject { ProjectOperation::Destroy.new(@members[0], @project) }

  describe '#process' do
    context 'when called' do

      it 'destroys the project' do
        subject.process
        expect( @project.destroyed? ).to be true
      end

    end
  end
end
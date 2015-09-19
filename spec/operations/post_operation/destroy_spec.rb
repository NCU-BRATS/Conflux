require 'rails_helper'

RSpec.describe PostOperation::Destroy do

  include_context 'post with project and creator'

  subject { PostOperation::Destroy.new(@members[0], @project, @post) }

  describe '#process' do
    context 'when called' do

      it 'soft delete the post' do
        subject.process
        expect( @post.deleted? ).to be true
      end

    end

  end
end

require 'rails_helper'

RSpec.describe CommentOperation::Destroy do

  include_context 'comment with commentable project and user'

  subject { CommentOperation::Destroy.new(@members[0], @comment) }

  describe '#process' do

    context 'when called' do

      it 'destroys the comment' do
        subject.process
        expect( @comment.destroyed? ).to be true
      end

      it 'fires corresponding event' do
        expect{ subject.process }.to broadcast( :on_comment_deleted )
      end

    end

  end
end

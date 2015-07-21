require "rails_helper"

RSpec.describe ReputationOperation::LikeOrUnlike do

  include_context 'comment with commentable project and user'
  
  describe '#process'  do

    subject { ReputationOperation::LikeOrUnlike.new(@members[0], @comment) }

    context 'when user likes a comment' do
      it 'add liked_user for the comment' do
        subject.process
        expect(@comment.liked_users.find{|r| r.id == @members[0].id}).not_to be nil
      end

      it 'creates a record for reputation_system' do
        subject.process
        expect(@comment.is_liked_by?(@members[0])).to be true
      end
    end

    context 'when user unlikes a comment' do

      before(:example) do
        @comment.add_evaluation(:likes, 1, @members[0])
        @comment.liked_users << @members[0]
        @comment.save
      end


      it 'delete liked_user for the comment' do
        subject.process
        expect(@comment.liked_users.find{|r| r.id == @members[0].id}).to be nil
      end

      it 'delete a record for reputation_system' do
        subject.process
        expect(@comment.is_liked_by?(@members[0])).to be false
      end

    end

  end

end
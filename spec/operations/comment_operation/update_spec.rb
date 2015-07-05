require 'rails_helper'

RSpec.describe CommentOperation::Update do

  include_context 'comment with commentable project and user'

  subject { CommentOperation::Update.new(@members[0], @comment) }

  describe '#process' do

    context 'when given valid params' do

      it 'changes the content' do
        subject.process( new_param( { comment: { content: 'change' } } ) )
        expect( @comment.content ).to eq 'change'
      end

      it 'adds new mentioned users to participations' do
        subject.process( new_param( { comment: { content: "change @#{@members[2].name}" } } ) )
        expect( @comment.participations.find {|p| p.user_id == @members[2].id} ).not_to be nil
      end

      it 'fires corresponding event' do
        param = new_param( { comment: { content: 'content_changed' } } )
        expect{ subject.process(param) }.to broadcast(:on_comment_updated)
      end
    end

    context 'when given incorrect params' do
      it 'raises ActionController::ParameterMissing' do
        expect{ CommentOperation::Update.new(@members[0], @comment).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end

  end

end


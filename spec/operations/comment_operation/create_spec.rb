require 'rails_helper'

RSpec.describe CommentOperation::Create do

  include_context 'commentable issue with project and user'

  describe '#process' do

    context 'when given valid params' do

      before(:example) do
        @params = new_param({ comment:{
          content: "testcontent @#{@members[1].name} ##{@issue.sequential_id}"
        }})
        @operation = CommentOperation::Create.new(@members[0], @commentable)
        @operation.process(@params)
      end

      it 'creates a comment with the given content, user and other attributes' do
        condiction = [
          @operation.model.content     == "testcontent @#{@members[1].name} ##{@issue.sequential_id}",
          @operation.model.user        == @members[0],
          @operation.model.commentable == @commentable
        ]
        expect(condiction).to all( be true )
      end

      it 'adds creator to participations' do
        expect(@operation.model.participations.find {|p| p.user_id == @members[0].id}).not_to be nil
      end

      it 'adds mentioned users to participations and mention list' do
        expect(@operation.model.participations.find {|p| p.user_id == @members[1].id}).not_to be nil
        expect(@operation.model.mentioned_list['members'].find {|p| p == @members[1].id}).not_to be nil
      end

      it 'adds mentioned issues to mention list' do
        expect(@operation.model.mentioned_list['issues'].find {|p| p == @issue.id}).not_to be nil
      end

      it 'fires corresponding event' do
        operation = CommentOperation::Create.new(@members[0], @commentable)
        expect{operation.process(@params)}.to broadcast(:on_comment_created)
      end
    end

    context 'when given incorrect params' do
      it 'raises ActionController::ParameterMissing' do
        expect{CommentOperation::Create.new(@members[0], @commentable).process(new_param)}.to raise_error ActionController::ParameterMissing
      end
    end

  end

end

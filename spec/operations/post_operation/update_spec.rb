require 'rails_helper'

RSpec.describe PostOperation::Update do

  include_context 'post with project and creator'

  subject { PostOperation::Update.new(@members[0], @project, @post) }

  describe '#process' do
    context 'when given valid params' do

      it 'changes the name' do
        subject.process(new_param({post: {name: 'name_changed'}}))
        expect(@post.name).to eq 'name_changed'
      end

      it 'changes the content' do
        subject.process(new_param({post: {content: 'content_changed'}}))
        expect(@post.content).to eq 'content_changed'
      end
    end

    context 'when given incorrect params' do
      it 'raise ActionController::ParameterMissing' do
        expect { subject.process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end

  end
end

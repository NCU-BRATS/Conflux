require 'rails_helper'

RSpec.describe SnippetOperation::Update do

  include_context 'snippet with project and creator'

  subject { SnippetOperation::Update.new(@members[0], @project, @snippet) }

  describe '#process' do
    context 'when given valid params' do

      it 'changes the name' do
        subject.process(new_param({snippet: {name: 'name_changed'}}))
        expect(@snippet.name).to eq 'name_changed'
      end

      it 'changes the content' do
        subject.process(new_param({snippet: {content: 'content_changed'}}))
        expect(@snippet.content).to eq 'content_changed'
      end

      it 'changes the language' do
        different_language = get_different_lang(@snippet.language)
        subject.process(new_param({snippet: {language: different_language}}))
        expect(@snippet.language).to eq different_language
      end
    end

    context 'when given incorrect params' do
      it 'raise ActionController::ParameterMissing' do
        expect { subject.process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end

  end
end

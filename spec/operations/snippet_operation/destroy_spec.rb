require 'rails_helper'

RSpec.describe SnippetOperation::Destroy do

  include_context 'snippet with project and creator'

  subject { SnippetOperation::Destroy.new(@members[0], @project, @snippet) }

  describe '#process' do
    context 'when called' do

      it 'destroys the snippet' do
        subject.process
        expect( @snippet.destroyed? ).to be true
      end

    end

  end
end

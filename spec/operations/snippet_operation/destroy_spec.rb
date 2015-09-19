require 'rails_helper'

RSpec.describe SnippetOperation::Destroy do

  include_context 'snippet with project and creator'

  subject { SnippetOperation::Destroy.new(@members[0], @project, @snippet) }

  describe '#process' do
    context 'when called' do

      it 'soft delete the snippet' do
        subject.process
        expect( @snippet.deleted? ).to be true
      end

    end

  end
end

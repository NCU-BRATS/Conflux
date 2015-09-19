require 'rails_helper'

RSpec.describe AttachmentOperation::Destroy do

  include_context 'project with members'

  subject {
    @attachment = Attachment.new
    @attachment.save(validate: false)
    AttachmentOperation::Destroy.new(@members[0], @project, @attachment)
  }

  describe '#process' do
    context 'when called' do

      it 'soft delete the post' do
        subject.process
        expect( @attachment.deleted? ).to be true
      end

    end

  end
end

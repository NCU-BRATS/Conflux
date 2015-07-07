require 'rails_helper'

RSpec.describe AttachmentOperation::Create do
  include_context 'project with members'

  describe '#process' do

    context 'when given valid params' do
      before(:context) do
        @params = new_param({ attachment:{
                                name: 'testname',
                                path: fake_uploaded_file("#{Rails.root}/spec/fixtures/images/test.png", "image/png")
                            }})

        @operation = AttachmentOperation::Create.new(@members[0], @project)
        @operation.process(@params)
      end

      it 'creates a record in database' do
        expect( @operation.model.persisted? ).to be true
      end

      it 'adds creator to participation' do
        expect( @operation.model.participations.find {|p| p.user_id == @members[0].id} ).not_to be nil
      end

      it 'creates an image if uploaded file is a image' do
        @operation = AttachmentOperation::Create.new(@members[0], @project)
        @params = new_param({ attachment:{
                                name: 'testname',
                                path: fake_uploaded_file("#{Rails.root}/spec/fixtures/images/test.png", "image/png")
                            }})
        @operation.process(@params)

        condition = [
            @operation.model.project == @project,
            @operation.model.user    == @members[0],
            @operation.model.name    == 'testname',
            @operation.model.is_a?(Image)
        ]
        expect(condition).to all( be true )
      end

      it 'creates an snippet with correct language detected if uploaded file is a snippet' do
        Dir['spec/fixtures/snippets/*'].each do |snippet|
          @operation = AttachmentOperation::Create.new(@members[0], @project)
          @params = new_param({ attachment:{
                                  name: 'testname',
                                  path: fake_uploaded_file("#{Rails.root}/#{snippet}", "text/plain")
                              }})
          @operation.process(@params)

          language_name = File.basename(snippet, File.extname(snippet))

          condition = [
              @operation.model.project == @project,
              @operation.model.user    == @members[0],
              @operation.model.name    == 'testname',
              @operation.model.language.casecmp(language_name).zero?,
              @operation.model.is_a?(Snippet)
          ]
          expect(condition).to all( be true )
        end
      end

      it 'creates an other_attachment if uploaded file is neither a snippet nor an image' do
        @operation = AttachmentOperation::Create.new(@members[0], @project)
        @params = new_param({ attachment:{
                                name: 'testname',
                                path: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/other_attachments/test.doc")
                            }})
        @operation.process(@params)

        condition = [
            @operation.model.project == @project,
            @operation.model.user    == @members[0],
            @operation.model.name    == 'testname',
            @operation.model.is_a?(OtherAttachment)
        ]
        expect(condition).to all( be true )
      end

      it 'fires corresponding event' do
        operation = AttachmentOperation::Create.new(@members[0], @project)
        expect{operation.process(@params)}.to broadcast(:on_attachment_created)
      end
    end

    context 'when given incorrect params'  do
      it 'raise ActionController::ParameterMissing' do
        expect{ AttachmentOperation::Create.new(@members[0], @project).process(new_param) }.to raise_error ActionController::ParameterMissing
      end
    end
  end
end

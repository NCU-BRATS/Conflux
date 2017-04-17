require 'rails_helper'

RSpec.describe V1::ProjectPostAPI, :type => :request  do

  describe 'POST attachment' do
    include_context 'project with members'
    include_context 'member jwts'

    context 'when given valid params' do
      before(:context) do
        post "/api/v1/projects/#{@project.id}/attachments",
             {
                 name: "test_name",
                 path: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/other_attachments/test.doc")
             },
             authorization_header( @jwts[0] )

      end

      it 'returns status 201' do
        expect( response ).to have_http_status( 201 )
      end

      it 'returns a attachment' do
        res = response.body.as_json
        conditions = [
            res['name']     == 'test_name',
        ]
        expect( conditions ).to all( be true )
      end


    end

    context 'when given invalid params' do
      it 'returns status 400 if params is not valid' do
        post "/api/v1/projects/#{@project.slug}/attachments"
        expect( response ).to have_http_status( 400 )
      end
    end

  end


end

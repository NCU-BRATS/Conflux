require 'rails_helper'

RSpec.describe V1::AuthAPI, :type => :request do
  include_context 'project with members'
  include_context 'member jwts'

  describe 'POST authentication' do
    context 'when given valid params' do
      before(:context) do
        post '/api/v1/authentication', usermail: @members[0].email, password: @members[0].password
      end

      it 'returns status 201' do
        expect( response ).to have_http_status( 201 )
      end

      it 'returns a jwt  ' do
        res = response.body.as_json
        conditions = [
            res['token']       != nil,
            res['expires_in']  != nil
        ]
        expect( conditions ).to all( be true )
      end
    end

    context 'when given invalid params' do
      it 'returns status 400 if param not exist' do
        post '/api/v1/authentication'
        expect( response ).to have_http_status( 400 )
      end

      it 'returns status 401 if param value is incorrect' do
        post '/api/v1/authentication', usermail: @members[0].email, password: @members[0].password + 'ggg'
        expect( response ).to have_http_status( 401 )
      end
    end
  end

  describe 'PUT authentication' do
    context 'when given valid params and header' do
      before(:context) do
        put '/api/v1/authentication', nil, authorization_header( @jwts[0] )
      end

      it 'returns status 200' do
        expect( response ).to have_http_status( 200 )
      end

      it 'returns a new jwt' do
        res = response.body.as_json
        conditions = [
            res['token']       != nil,
            res['token']       != @jwts[0],
            res['expires_in']  != nil
        ]
        expect( conditions ).to all( be true )
      end
    end

    context 'when given invalid params or header' do
      it 'returns 400 if jwt not provided in correct way' do
        put '/api/v1/authentication', nil, invalid_authorization_header( @jwts[0] )
        expect( response ).to have_http_status( 400 )
      end

      it 'returns 400 if jwt not provided in correct way' do
        put '/api/v1/authentication', nil
        expect( response ).to have_http_status( 400 )
      end

      it 'returns 401 if jwt is invalid' do
        put '/api/v1/authentication', nil, authorization_header( 'wrongtoken' )
        expect( response ).to have_http_status( 401 )
      end
    end
  end

  describe 'DELETE authentication' do
    context 'when given valid params and header' do
      before(:context) do
        delete '/api/v1/authentication', nil, authorization_header( @jwts[1] )
      end

      it 'returns status 204' do
        expect( response ).to have_http_status( 204 )
      end
    end
  end

end

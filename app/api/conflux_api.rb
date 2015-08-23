class ConfluxAPI < Grape::API
  format :json

  helpers GrapeHelper

  rescue_from Grape::Exceptions::Base do |e|
    error!( { message: e.message } , e.status )
  end

  rescue_from :all do |e|
    ConfluxAPI.logger.error e
    error!( { message: 'sever internal error' } , 500 )
  end

  namespace :v1 do
    mount V1::AuthAPI

    group do
      before do
        authenticate_api_user!
      end
      resources :projects do
        mount V1::ProjectAPI
      end
    end
  end

end

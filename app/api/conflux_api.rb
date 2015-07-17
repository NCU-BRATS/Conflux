class ConfluxAPI < Grape::API
  format :json

  mount Auth::V1
end

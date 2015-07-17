module Auth
  class V1 < Grape::API
    version 'v1'

    get :hello do
      { hello: 'world' }
    end
  end
end

module ApiHelper

  def authorization_header( jwt, headers = {} )
    headers.merge( { Authorization: 'Bearer ' + jwt } )
  end

  def invalid_authorization_header( jwt, headers = {} )
    headers.merge( { Authorization: 'Bear ' + jwt } )
  end

end

@Ajaxer =

  patch: ( setting ) ->

    @ajax( 'PATCH', setting )

  post: ( setting ) ->

    @ajax( 'POST', setting )

  put: ( setting ) ->

    @ajax( 'PUT', setting )

  ajax: ( method, setting ) ->

    path = setting.path
    data = setting.data
    done = setting.done
    fail = setting.fail

    $.ajax( path, {
      method: method
      data: data
    })
    .done ( data, status, xhr ) =>
      done( data, status, xhr ) if done
    .fail ( xhr, status, err ) =>
      if fail
        fail( xhr, status, err )
      else
        console.log( err )
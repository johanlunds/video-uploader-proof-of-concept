@app.factory 'uploadService', ($http) ->

  root = "http://localhost:4000"

  @run = ->
    $http
      .post(root + '/videos', { video: { title: "bar" } })
      .then (resp) -> alert(JSON.stringify(resp))

  return @
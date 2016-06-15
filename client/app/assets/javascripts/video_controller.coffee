@app.controller 'VideoController', (uploadService) ->

  @form = {}
  @progressPercentage = null

  @upload = ->
    onFinished = -> alert("upload done!")
    onError = (e) -> alert("something went wrong")
    onProgress = (event) =>
      @progressPercentage = parseInt(100.0 * event.loaded / event.total)

    uploadService
      .run(@form)
      .then(onFinished, onError, onProgress)

  return @
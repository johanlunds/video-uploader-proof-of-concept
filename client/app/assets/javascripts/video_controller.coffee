@app.controller 'VideoController', (VideoUpload) ->

  @form = {}
  @progressPercentage = null

  @upload = ->
    onFinished = -> alert("upload done!")
    onError = (e) -> alert("something went wrong")
    onProgress = (event) =>
      @progressPercentage = parseInt(100.0 * event.loaded / event.total)

    @upload = new VideoUpload(@form)
    @upload
      .run()
      .then(onFinished, onError, onProgress)

  return @
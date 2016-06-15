@app.controller 'VideoController', (VideoUpload) ->

  @form = {}
  @progressPercentage = null

  @upload = ->
    onFinished = -> alert("upload done!")
    onError = (e) -> alert("something went wrong")
    onProgress = (event) =>
      @progressPercentage = parseInt(100.0 * event.loaded / event.total)

    @currentUpload = new VideoUpload(@form)
    @currentUpload
      .run()
      .then(onFinished, onError, onProgress)

  return @
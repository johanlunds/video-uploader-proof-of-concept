@app.controller 'VideoController', (VideoUpload) ->

  @form = {}
  @progressPercentage = null
  @working = false

  @upload = ->
    onFinished = -> alert("upload done!")
    onError = (e) -> alert("something went wrong")
    onProgress = (event) =>
      @progressPercentage = parseInt(100.0 * event.loaded / event.total)

    @working = true
    @currentUpload = new VideoUpload(@form)
    @currentUpload
      .run()
      .then(onFinished, onError, onProgress)
      .finally => @working = false

  return @
@app.controller 'VideoController', (uploadService) ->

  @form = {}

  @upload = ->
    onFinished = -> alert("upload done!")
    onProgress = (event) ->
      progressPercentage = parseInt(100.0 * event.loaded / event.total)
      console.log 'progress: ' + progressPercentage + '% '
    onError = (e) -> alert("something went wrong")

    uploadService
      .run(@form)
      .then(onFinished, onError, onProgress)

  return @
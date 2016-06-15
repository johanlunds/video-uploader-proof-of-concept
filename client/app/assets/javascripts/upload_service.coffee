# TODO: remove
@app.factory 'uploadService', (VideoUpload) ->

  @run = (form) ->
    upload = new VideoUpload(form)
    upload.run()

  return @
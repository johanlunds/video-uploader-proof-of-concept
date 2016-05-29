@app.controller 'VideoController', (uploadService) ->

  @form = {}

  @upload = ->
    uploadService.run(@form)

  return @
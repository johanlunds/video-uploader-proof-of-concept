# https://github.com/dailymotion/hls.js
# http://stackoverflow.com/questions/18434803/how-can-i-play-apple-hls-live-stream-using-html5-video-tag
@app.directive 'hlsVideo', ->
  restrict: 'A'
  scope:
    hlsVideoSrc: '='
  link: (scope, element) ->
    if Hls.isSupported()
      video = element[0]
      hls = new Hls()
      hls.loadSource scope.hlsVideoSrc
      hls.attachMedia video
      hls.on Hls.Events.MANIFEST_PARSED, ->
        video.play()
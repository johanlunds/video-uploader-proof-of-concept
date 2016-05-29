@app.factory 'uploadService', ($http, Upload) ->

  root = "http://localhost:4000"

  @run = (form) ->
    # 1. Generate presigned S3 POST
    #
    # Response example:
    #
    # {
    #   "id": 23,
    #   "uuid": "34ca0134-3717-4ffd-b064-c4371bad821d",
    #   "presigned_post": {
    #     "form-data": {
    #       "key": "uploads/34ca0134-3717-4ffd-b064-c4371bad821d",
    #       "success_action_status": "201",
    #       "acl": "private",
    #       "policy": "eyJleHBpcasdasdoopkasdODowMDoxMFoiLCasdasdXQiOiJqb2hhbmx1bmRzLXZpZGVvLXVwbG9hZCJ9LHsia2V5IjoidXBsb2Fkcy8zNGNhMDEzNC0zNzE3LTRmZmQtYjA2NC1jNDM3MWJhZDgyMWQifSx7InN1Y2Nlc3NfYWN0aW9uX3N0YXR1cyI6IjIwMSJ9LHsiYWNsIjoicHJpdmF0ZSJ9LHsieC1hbXotY3JlZGVudGlhbCI6IkFLSUFJSUJHVFE3Nlc3WFFLRlJBLzIwMTYwNTI4L3VzLXdlc3QtMi9zMy9hd3M0X3JlcXVlc3QifSx7IngtYW16LWFsZ29yaXRobSI6IkFXUzQtSE1BQy1TSEEyNTYifSx7IngtYW16LWRhdGUiOiIyMDE2MDUyOFQxNzAwMTBaIn1dfQ==",
    #       "x-amz-credential": "AKIAI123324234/20160528/us-west-2/s3/aws4_request",
    #       "x-amz-algorithm": "AWS4-HMAC-SHA256",
    #       "x-amz-date": "20160528T170010Z",
    #       "x-amz-signature": "4asdasdsadasdasdasdasder43tsgfdg556a77e8f81a343087f0b8dfaaf0c54287f1ea"
    #     },
    #     "url": "https://johanlunds-video-upload.s3-us-west-2.amazonaws.com",
    #     "host": "johanlunds-video-upload.s3-us-west-2.amazonaws.com"
    #   }
    # }
    createPresignedPost = ->
      $http
        .post(root + '/videos/upload', {})
        .then (resp) -> resp.data

    # TODO: research "multipart uploads" (aka. "resumable uploads"). http://docs.aws.amazon.com/AmazonS3/latest/dev/uploadobjusingmpu.html
    #       "In general, when your object size reaches 100 MB, you should consider using multipart uploads instead of uploading the object in a single operation."
    #
    # TODO: research bucket lifecycle policies for S3 "johanlunds-video-upload". http://docs.aws.amazon.com/AmazonS3/latest/dev/object-lifecycle-mgmt.html
    #
    # TODO: use presigned *urls* instead? Difference? They have expiration. http://docs.aws.amazon.com/AmazonS3/latest/dev/PresignedUrlUploadObject.html
    #
    # Construct form like:
    #
    # <form action="<%= @post.url %>" method="post" enctype="multipart/form-data">
    #
    #   <% @post.fields.each do |name, value| %>
    #     <input type="hidden" name="<%= name %>" value="<%= value %>"/>
    #   <% end %>
    #
    #   <input type="file" name="file"/>
    #
    # </form>
    uploadFileToS3 = (upload) ->
      # Order of params seem important.
      # "Bucket POST must contain a field named 'key'. If it is specified, please check the order of the fields."
      # http://stackoverflow.com/questions/6943138/changing-the-sequence
      data = Object.assign(
        {},
        upload.presigned_post['form-data'],
        { file: form.file },
      )
      # https://github.com/danialfarid/ng-file-upload
      #
      # Example response:
      #
      # <PostResponse>
      # <Location>https://johanlunds-video-upload.s3-us-west-2.amazonaws.com/uploads%2F0e88399e-1167-4ae4-96b3-27c4af41cab8</Location>
      # <Bucket>johanlunds-video-upload</Bucket>
      # <Key>uploads/0e88399e-1167-4ae4-96b3-27c4af41cab8</Key>
      # <ETag>"b1cad9e8d5c00844ca214a28c9590134"</ETag>
      # </PostResponse>
      #
      # TODO: nice thing = show upload progress bar
      Upload.upload(
        method: 'POST'
        url: upload.presigned_post.url
        data: data
        headers: { 'Accept': 'application/xml' } # "success_action_status=201" will make it return XML
      ).then (resp) ->
        upload
      ,
      null,
      (event) ->
        progressPercentage = parseInt(100.0 * event.loaded / event.total)
        console.log 'progress: ' + progressPercentage + '% '

    createVideo = (upload) ->
      data = Object.assign(
        {},
        { title: form.title },
        { video_upload_id: upload.id }
      )
      $http
        .post(root + '/videos', data)
        .then (resp) -> resp.data

    createPresignedPost()
      .then uploadFileToS3
      .then createVideo
      .then -> alert("upload done!")
      .catch (e) -> alert("something went wrong")

  return @
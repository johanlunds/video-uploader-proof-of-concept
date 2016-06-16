## General flow:

1. post /videos/uploads.
  * should be authenticated
  * create row in db
2. return S3 info + db id
3. upload video to bucket #1
4. post db id + other info to post /videos
  * set state = processing
5. on S3 upload finished post to SNS topic (that does PUT /videos/uploads/:id)
6. create job in Elastic Transcoder
7. move results + original to bucket #2
8. post to SNS when Elastic Transcoder finished (that does PUT /videos/upload/:id)
9. set state = processed
10. show response + video in Client.

## Screenshot

<img src="https://www.evernote.com/l/AJss5ErihYBCAZmI2xhRH_KOTIPCbvO8zaIB/image.png" width="50%" height="50%" />

## Docker

### Locally

```
docker-compose up
docker-compose run server rake db:create
open http://localhost:3000

docker-compose -f docker-compose.yml -f docker-compose.development.yml up -d
```

### Remotely on EC2

```
docker-machine create --amazonec2-region us-west-2 --driver amazonec2 --amazonec2-vpc-id $VPC_ID --amazonec2-subnet-id $SUBNET_ID --amazonec2-zone c  video-uploads-docker-test
eval $(docker-machine env video-uploads-docker-test)

docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
```

Re-deploy after changes:

```
docker-compose build client client_assets
docker-compose up --no-deps -d client client_assets
```


## How to get SNS notifications to work when running locally:

```
./ngrok http 4000
```

Set up SNS to POST to:

```
http://3e253438.ngrok.io/video_uploads/sns_notifications
```


## Todos/improvements

* [ ] mount Sqlite3 volume or switch to Postgres
  * Currently `docker-compose -f docker-compose.yml -f docker-compose.production.yml exec server bundle exec rake db:setup`
* [ ] Build a mobile app as client
* [ ] try out Gitlab Docker CI/CD
* [ ] try out CoreOS/Kubernetes/Mesos
  * http://blog.cloud66.com/9-crtitical-decisions-needed-to-run-docker-in-production/
* [ ] replace alert-dialogs in VideoController with UI
* [ ] Known issue: application.js/application.css are not loaded correctly sometimes. Probably a race condition when starting the services in Docker
* [ ] TODOs in code for improvements and proper error handling for a real production app:

    ```
    ✗ grep -Rni TODO server/app client/app
    server/app/controllers/video_uploads_controller.rb:16:  # TODO: endpoint should be authenticated. add user relation to VideoUpload
    server/app/controllers/video_uploads_controller.rb:41:  # TODO: set up proper HTTPS + Basic auth here?
    server/app/controllers/video_uploads_controller.rb:84:      # TODO: handle response?!
    server/app/models/video_upload.rb:63:      content_length_range: 1..(3.gigabytes), # TODO: does not work? wrong option name perhaps?
    server/app/models/video_upload.rb:64:      # content_type_starts_with: 'video/', # TODO: does not work? :S
    server/app/models/video_upload.rb:100:      # TODO: multiple bitrates - how?
    server/app/models/video_upload.rb:101:      # TODO: create video thumbnails - for moderation.
    server/app/models/video_upload.rb:125:      # TODO: should use another, new UUID for this? Should use another table/row/record for submitting to Elastic Transcode, to handle resubmits/retranscodes/failures/retries?
    server/app/services/video_upload_sns_notification_handler.rb:79:    # TODO: handle multiple files (?) and multipart upload events:
    server/app/services/video_upload_sns_notification_handler.rb:146:    # TODO: handle more events including errors. see notes in VideoUpload#create_elastic_transcoder_job
    client/app/assets/javascripts/video_upload.coffee:48:    # TODO: research "multipart uploads" (aka. "resumable uploads"). http://docs.aws.amazon.com/AmazonS3/latest/dev/uploadobjusingmpu.html
    client/app/assets/javascripts/video_upload.coffee:59:    # TODO: research bucket lifecycle policies for S3 "johanlunds-video-upload". http://docs.aws.amazon.com/AmazonS3/latest/dev/object-lifecycle-mgmt.html
    client/app/assets/javascripts/video_upload.coffee:60:    # TODO: clean up & move original to separate bucket for saving after upload + processing finished
    client/app/assets/javascripts/video_upload.coffee:62:    # TODO: use presigned *urls* instead? Difference? They have expiration. http://docs.aws.amazon.com/AmazonS3/latest/dev/PresignedUrlUploadObject.html
    ```

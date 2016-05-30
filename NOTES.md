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

## How to get SNS notifications to work when running locally:

```
./ngrok http 4000
```

Set up SNS to POST to:

```
http://3e253438.ngrok.io/video_uploads/sns_notifications
```
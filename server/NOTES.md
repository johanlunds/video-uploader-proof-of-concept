1. post /videos/s3.
  * should be authenticated
  * create row in db
2. return S3 info + db id
3. upload video to bucket #1
4. post db id + other info to post /videos
  * set state = processing
5. process in Elastic Transcoder via event-hook in SNS
6. move results + original to bucket #2
7. SNS to Rails about finished
8. set state = processed
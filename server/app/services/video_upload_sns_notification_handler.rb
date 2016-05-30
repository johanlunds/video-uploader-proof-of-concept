class VideoUploadSNSNotificationHandler
  # Example S3 Notification:
  #
  # {"Type"=>"Notification",
  #  "MessageId"=>"19a0714c-5338-575b-ab81-3e89f07c0ec8",
  #  "TopicArn"=>"arn:aws:sns:us-west-2:784245509715:video_uploads_s3",
  #  "Subject"=>"Amazon S3 Notification",
  #  "Message"=>
  #   "{\"Records\":[{\"eventVersion\":\"2.0\",\"eventSource\":\"aws:s3\",\"awsRegion\":\"us-west-2\",\"eventTime\":\"2016-05-30T02:10:12.722Z\",\"eventName\":\"ObjectCreated:Post\",\"userIdentity\":{\"principalId\":\"AWS:***REMOVED***\"},\"requestParameters\":{\"sourceIPAddress\":\"***REMOVED***\"},\"responseElements\":{\"x-amz-request-id\":\"4FB3974093AFF77B\",\"x-amz-id-2\":\"5fqjqmW8NVJV5a6k0mlUQo60OzAdTfz9LFxJJVTDHNFXpu9qwsE+lEHGjxFlXTQQBW9avAPIMH8=\"},\"s3\":{\"s3SchemaVersion\":\"1.0\",\"configurationId\":\"VideoUploadsNotify\",\"bucket\":{\"name\":\"johanlunds-video-upload\",\"ownerIdentity\":{\"principalId\":\"***REMOVED***\"},\"arn\":\"arn:aws:s3:::johanlunds-video-upload\"},\"object\":{\"key\":\"uploads/20f5f9c1-1ce4-4c48-b10f-709117e20e2a\",\"size\":13414967,\"eTag\":\"b1cad9e8d5c00844ca214a28c9590134\",\"sequencer\":\"00574BA0FC2F384A25\"}}}]}",
  #  "Timestamp"=>"2016-05-30T02:10:12.812Z",
  #  "SignatureVersion"=>"1",
  #  "Signature"=>
  #   "HdYA9a4D7iFHMc5ge4YoFgJsQCDv+uCqgIiLOGigy7et8uquwDxLAj5LfOXuXaFoEjX4+cu2Y2qF2D9NID/OKXiKR2iwMn2ysvNS+9uVi2Z4kBw2vLu1d+YOGJzjIWbYpeKgkV6j5rREerNZ8+x+a/8WruIWgTelJlvXprns55YSuwgGs6MO17rT1l5LtstbR0htdU/vGv2kfKWbwmstGZxkJ5NOAkOmK75ap/+7DqVZVMl1h0dCmhF9lhHB/yCc/fe/YKFMN/toM3h0ACZKsZ/MRcSjFKfPdEQFPSR+gFXOHQqnoZ2sojptN62Gg1J4TMxz484fNWp4akqZ76I/4w==",
  #  "SigningCertURL"=>
  #   "https://sns.us-west-2.amazonaws.com/SimpleNotificationService-bb750dd426d95ee9390147a5624348ee.pem",
  #  "UnsubscribeURL"=>
  #   "https://sns.us-west-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-west-2:784245509715:video_uploads_s3:c4c18f2f-3069-4bfa-8fae-90572e859d22"}
  #
  # Example S3 Message:
  #
  # {"Records"=>
  #   [{"eventVersion"=>"2.0",
  #     "eventSource"=>"aws:s3",
  #     "awsRegion"=>"us-west-2",
  #     "eventTime"=>"2016-05-30T02:03:39.962Z",
  #     "eventName"=>"ObjectCreated:Post",
  #     "userIdentity"=>{"principalId"=>"AWS:***REMOVED***"},
  #     "requestParameters"=>{"sourceIPAddress"=>"***REMOVED***"},
  #     "responseElements"=>
  #      {"x-amz-request-id"=>"C79B9EFA90D99A62",
  #       "x-amz-id-2"=>
  #        "7LvLTReTiEP4gaXfgiX6eLClHUw8OYPByUGnD0B3D1A5BLYzrulEJr7H24263UKX1XdZwebT1Ho="},
  #     "s3"=>
  #      {"s3SchemaVersion"=>"1.0",
  #       "configurationId"=>"VideoUploadsNotify",
  #       "bucket"=>
  #        {"name"=>"johanlunds-video-upload",
  #         "ownerIdentity"=>{"principalId"=>"***REMOVED***"},
  #         "arn"=>"arn:aws:s3:::johanlunds-video-upload"},
  #       "object"=>
  #        {"key"=>"uploads/e4840cb9-a09c-45e4-bf4f-9445936c862f",
  #         "size"=>13414967,
  #         "eTag"=>"b1cad9e8d5c00844ca214a28c9590134",
  #         "sequencer"=>"00574B9F6F1F029074"}}}]}
  #
  # Example Transcoder Notification:
  #
  # {"Type"=>"Notification",
  #  "MessageId"=>"e8b8c107-a693-5ef4-a815-8ec2056b573f",
  #  "TopicArn"=>
  #   "arn:aws:sns:us-west-2:784245509715:video_uploads_elastictranscoder",
  #  "Subject"=>
  #   "Amazon Elastic Transcoder has scheduled job 1464574390308-dd3t38 for transcoding.",
  #  "Message"=>
  #   "{\n  \"state\" : \"PROGRESSING\",\n  \"version\" : \"2012-09-25\",\n  \"jobId\" : \"1464574390308-dd3t38\",\n  \"pipelineId\" : \"1464551986249-lqqtib\",\n  \"input\" : {\n    \"key\" : \"uploads/20f5f9c1-1ce4-4c48-b10f-709117e20e2a\"\n  },\n  \"outputKeyPrefix\" : \"hlsv4/20f5f9c1-1ce4-4c48-b10f-709117e20e2a/\",\n  \"outputs\" : [ {\n    \"id\" : \"1\",\n    \"presetId\" : \"1351620000001-200055\",\n    \"key\" : \"hls_video_400k\",\n    \"segmentDuration\" : 10.0,\n    \"status\" : \"Progressing\"\n  }, {\n    \"id\" : \"2\",\n    \"presetId\" : \"1351620000001-200071\",\n    \"key\" : \"hls_audio_64k\",\n    \"segmentDuration\" : 10.0,\n    \"status\" : \"Progressing\"\n  } ],\n  \"playlists\" : [ {\n    \"name\" : \"index\",\n    \"format\" : \"HLSv4\",\n    \"outputKeys\" : [ \"hls_video_400k\", \"hls_audio_64k\" ],\n    \"status\" : \"Progressing\"\n  } ]\n}",
  #  "Timestamp"=>"2016-05-30T02:13:12.258Z",
  #  "SignatureVersion"=>"1",
  #  "Signature"=>
  #   "dC12vOPxk5APfVREc8oMRYOBuApqoyrjkNQTc4zGxO/0eeb1gv2f6DC9k0kr3R4T1BRiCwoZo49rtZDQweU/06j5qsmYanIuIm5deNhNGiJ+XaFt7ThffRWkd52VMcnFP81oKhUMSbjF7FN8cTX0izlfD298p8B09/4hgg0YPs83LJJRkc0eTT3Drw2xl1Uu1oVsiXEdX+ab86J9SEKA0tE1ZukJIbKoDRhweCmgmbowNjuemS8PN7cRkjRHiXH6pv18D8ULgtnpty2uRLUKgsIXMD01ytbEC+mXrl0WD+aX20USrPrTGBGMDLRmnY9zhJRxPniuCfpkC6q5i6ZKPg==",
  #  "SigningCertURL"=>
  #   "https://sns.us-west-2.amazonaws.com/SimpleNotificationService-bb750dd426d95ee9390147a5624348ee.pem",
  #  "UnsubscribeURL"=>
  #   "https://sns.us-west-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-west-2:784245509715:video_uploads_elastictranscoder:deeb63d1-7a0a-4edc-b73f-733b6e2411cc"}
  #
  # Example Transcoder Messages:
  #
  # {"state"=>"PROGRESSING",
  #  "version"=>"2012-09-25",
  #  "jobId"=>"1464573987335-ooj6wu",
  #  "pipelineId"=>"1464551986249-lqqtib",
  #  "input"=>{"key"=>"uploads/e4840cb9-a09c-45e4-bf4f-9445936c862f"},
  #  "outputKeyPrefix"=>"hlsv4/e4840cb9-a09c-45e4-bf4f-9445936c862f/",
  #  "outputs"=>
  #   [{"id"=>"1",
  #     "presetId"=>"1351620000001-200055",
  #     "key"=>"hls_video_400k",
  #     "segmentDuration"=>10.0,
  #     "status"=>"Progressing"},
  #    {"id"=>"2",
  #     "presetId"=>"1351620000001-200071",
  #     "key"=>"hls_audio_64k",
  #     "segmentDuration"=>10.0,
  #     "status"=>"Progressing"}],
  #  "playlists"=>
  #   [{"name"=>"index",
  #     "format"=>"HLSv4",
  #     "outputKeys"=>["hls_video_400k", "hls_audio_64k"],
  #     "status"=>"Progressing"}]}
  #
  # {"state"=>"COMPLETED",
  #  "version"=>"2012-09-25",
  #  "jobId"=>"1464573987335-ooj6wu",
  #  "pipelineId"=>"1464551986249-lqqtib",
  #  "input"=>{"key"=>"uploads/e4840cb9-a09c-45e4-bf4f-9445936c862f"},
  #  "outputKeyPrefix"=>"hlsv4/e4840cb9-a09c-45e4-bf4f-9445936c862f/",
  #  "outputs"=>
  #   [{"id"=>"1",
  #     "presetId"=>"1351620000001-200055",
  #     "key"=>"hls_video_400k",
  #     "segmentDuration"=>10.0,
  #     "status"=>"Complete",
  #     "duration"=>597,
  #     "width"=>400,
  #     "height"=>224},
  #    {"id"=>"2",
  #     "presetId"=>"1351620000001-200071",
  #     "key"=>"hls_audio_64k",
  #     "segmentDuration"=>10.0,
  #     "status"=>"Complete",
  #     "duration"=>597}],
  #  "playlists"=>
  #   [{"name"=>"index",
  #     "format"=>"HLSv4",
  #     "outputKeys"=>["hls_video_400k", "hls_audio_64k"],
  #     "status"=>"Complete"}]}
  def self.handle(notification)
    msg = JSON.parse(msg)
    pp msg
  end
end
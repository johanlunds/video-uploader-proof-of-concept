class VideoUploadsController < ApplicationController
  before_action :set_video_upload, only: [:show, :update, :destroy]

  # GET /video_uploads
  def index
    @video_uploads = VideoUpload.all

    render json: @video_uploads
  end

  # GET /video_uploads/1
  def show
    render json: @video_upload
  end

  # TODO: endpoint should be authenticated. add user relation to VideoUpload
  #
  # POST /video_uploads
  def create
    @video_upload = VideoUpload.new
    @video_upload.save!
    @video_upload.prepare!

    render json: @video_upload, status: :created, location: @video_upload
  end

  # PATCH/PUT /video_uploads/1
  def update
    if @video_upload.update(video_upload_params)
      render json: @video_upload
    else
      render json: @video_upload.errors, status: :unprocessable_entity
    end
  end

  # DELETE /video_uploads/1
  def destroy
    @video_upload.destroy
  end

  # TODO: set up proper HTTPS + Basic auth here?
  #
  # https://gist.github.com/akiatoji/4489390
  # http://docs.aws.amazon.com/sns/latest/dg/SendMessageToHttp.html
  # http://docs.aws.amazon.com/sdkforruby/api/Aws/SNS/Client.html#confirm_subscription-instance_method
  #
  # Example SubscriptionConfirmation:
  #
  # {
  #   "Type" : "SubscriptionConfirmation",
  #   "MessageId" : "165545c9-2a5c-472c-8df2-7ff2be2b3b1b",
  #   "Token" : "2336412f37fb687f5d51e6e241d09c805a5a57b30d712f794cc5f6a988666d92768dd60a747ba6f3beb71854e285d6ad02428b09ceece29417f1f02d609c582afbacc99c583a916b9981dd2728f4ae6fdb82efd087cc3b7849e05798d2d2785c03b0879594eeac82c01f235d0e717736",
  #   "TopicArn" : "arn:aws:sns:us-west-2:123456789012:MyTopic",
  #   "Message" : "You have chosen to subscribe to the topic arn:aws:sns:us-west-2:123456789012:MyTopic.\nTo confirm the subscription, visit the SubscribeURL included in this message.",
  #   "SubscribeURL" : "https://sns.us-west-2.amazonaws.com/?Action=ConfirmSubscription&TopicArn=arn:aws:sns:us-west-2:123456789012:MyTopic&Token=2336412f37fb687f5d51e6e241d09c805a5a57b30d712f794cc5f6a988666d92768dd60a747ba6f3beb71854e285d6ad02428b09ceece29417f1f02d609c582afbacc99c583a916b9981dd2728f4ae6fdb82efd087cc3b7849e05798d2d2785c03b0879594eeac82c01f235d0e717736",
  #   "Timestamp" : "2012-04-26T20:45:04.751Z",
  #   "SignatureVersion" : "1",
  #   "Signature" : "EXAMPLEpH+DcEwjAPg8O9mY8dReBSwksfg2S7WKQcikcNKWLQjwu6A4VbeS0QHVCkhRS7fUQvi2egU3N858fiTDN6bkkOxYDVrY0Ad8L10Hs3zH81mtnPk5uvvolIC1CXGu43obcgFxeL3khZl8IKvO61GWB6jI9b5+gLPoBc1Q=",
  #   "SigningCertURL" : "https://sns.us-west-2.amazonaws.com/SimpleNotificationService-f3ecfb7224c7233fe7bb5f59f96de52f.pem"
  # }
  #
  # Example Notification:
  #
  # {
  #   "Type" : "Notification",
  #   "MessageId" : "22b80b92-fdea-4c2c-8f9d-bdfb0c7bf324",
  #   "TopicArn" : "arn:aws:sns:us-west-2:123456789012:MyTopic",
  #   "Subject" : "My First Message",
  #   "Message" : "Hello world!",
  #   "Timestamp" : "2012-05-02T00:54:06.655Z",
  #   "SignatureVersion" : "1",
  #   "Signature" : "EXAMPLEw6JRNwm1LFQL4ICB0bnXrdB8ClRMTQFGBqwLpGbM78tJ4etTwC5zU7O3tS6tGpey3ejedNdOJ+1fkIp9F2/LmNVKb5aFlYq+9rk9ZiPph5YlLmWsDcyC5T+Sy9/umic5S0UQc2PEtgdpVBahwNOdMW4JPwk0kAJJztnc=",
  #   "SigningCertURL" : "https://sns.us-west-2.amazonaws.com/SimpleNotificationService-f3ecfb7224c7233fe7bb5f59f96de52f.pem",
  #   "UnsubscribeURL" : "https://sns.us-west-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-west-2:123456789012:MyTopic:c9135db0-26c4-47ec-8998-413945fb5a96"
  # }
  def sns_notifications
    notification = Hashie::Mash.new(JSON.parse(request.raw_post))

    case notification.Type
    when "SubscriptionConfirmation"
      sns = Aws::SNS::Client.new
      # TODO: handle response?!
      #
      # <ConfirmSubscriptionResponse xmlns="http://sns.amazonaws.com/doc/2010-03-31/">
      #   <ConfirmSubscriptionResult>
      #     <SubscriptionArn>arn:aws:sns:us-west-2:123456789012:MyTopic:2bcfbf39-05c3-41de-beaa-fcfcc21c8f55</SubscriptionArn>
      #   </ConfirmSubscriptionResult>
      #   <ResponseMetadata>
      #     <RequestId>075ecce8-8dac-11e1-bf80-f781d96e9307</RequestId>
      #   </ResponseMetadata>
      #   </ConfirmSubscriptionResponse>
      resp = sns.confirm_subscription({
        topic_arn: notification.TopicArn,
        token: notification.Token,
      })
    when "Notification"
      VideoUploadSNSNotificationHandler.handle(notification.Message)
    else
      raise "Unknown notification type #{notification.Type}"
    end

    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_upload
      @video_upload = VideoUpload.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def video_upload_params
      params.fetch(:video_upload, {})
    end
end

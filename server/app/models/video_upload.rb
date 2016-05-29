class VideoUpload < ApplicationRecord
  has_one :video

  serialize :presigned_post, JSON

  include Workflow

  workflow_column :status
  workflow do
    state :new do
      event :prepare, transitions_to: :uploading
    end
    state :uploading do
      event :uploaded, transitions_to: :processing
    end
    state :processing do
      event :processed, transitions_to: :finished
    end
    state :finished
  end

  before_create :generate_uuid

  def prepare
    # upload
    create_presigned_post
  end

  def uploaded
    # process
    create_elastic_transcoder_job
  end

  def processed
    # finish
    video.publish!
  end

  private

  def generate_uuid
    begin
      self.uuid = SecureRandom.uuid
    end while self.class.exists?(uuid: uuid)
  end

  # http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/PresignedPost.html
  # https://devcenter.heroku.com/articles/direct-to-s3-image-uploads-in-rails
  def create_presigned_post
    s3_bucket = Aws::S3::Resource.new.bucket(ENV['S3_UPLOAD_BUCKET'])

    s3_direct_post = s3_bucket.presigned_post(
      key: "uploads/#{uuid}",
      success_action_status: '201',
      acl: 'private', # no public read
      content_length_range: 1..(3.gigabytes), # TODO: does not work? wrong option name perhaps?
      # content_type_starts_with: 'video/', # TODO: does not work? :S
      metadata: {
        'original-filename': '${filename}'
      },
    )
    self.presigned_post = {
      'form-data' => s3_direct_post.fields,
      'url' => s3_direct_post.url,
      'host' => URI.parse(s3_direct_post.url).host,
    }
  end

  # https://medium.com/@randika/aws-ruby-sdk-and-elastic-transcoder-example-c6c34fb5bc32#.5s897kmem
  def create_elastic_transcoder_job

  end
end

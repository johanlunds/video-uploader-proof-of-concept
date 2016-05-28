class VideoUpload < ApplicationRecord
  serialize :presigned_post, JSON

  before_create :generate_uuid
  before_create :create_presigned_post

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
      acl: 'private' # no public read
      # content_length_range: 1..(10*1024),
      # content_type_starts_with: 'video/',
      # metadata: {
      #   'original-filename': '${filename}'
      # },
    )
    self.presigned_post = {
      'form-data' => s3_direct_post.fields,
      'url' => s3_direct_post.url,
      'host' => URI.parse(s3_direct_post.url).host,
    }
  end
end
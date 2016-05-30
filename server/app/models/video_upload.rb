class VideoUpload < ApplicationRecord
  has_one :video

  serialize :presigned_post, JSON
  serialize :transcoder_job_data, JSON

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
  #
  # Useful pages:
  #
  # * https://console.aws.amazon.com/elastictranscoder/home?region=us-west-2#presets:
  # * https://console.aws.amazon.com/elastictranscoder/home?region=us-west-2#create-job:
  # * http://docs.aws.amazon.com/elastictranscoder/latest/developerguide/introduction.html
  # * http://aws.amazon.com/elastictranscoder/
  def create_elastic_transcoder_job
    # uses region + credentials from Aws.config
    transcoder = Aws::ElasticTranscoder::Client.new

    # HLSV4
    # https://aws.amazon.com/blogs/aws/ets-hls4-support/
    # "This adaptive streaming protocol is commonly used by newer iOS (5+) and Android (4.4+) devices."
    #
    # HLS4 should have separate audio + video outputs/tracks.
    options = {
      # arn:aws:elastictranscoder:us-west-2:784245509715:pipeline/1464551986249-lqqtib
      # Test video_uploads
      pipeline_id: "1464551986249-lqqtib",
      input: {
        key: presigned_post['form-data']['key']
      },
      # TODO: multiple bitrates - how?
      # TODO: create video thumbnails - for moderation.
      outputs: [
        {
          key: "hls_video_400k",
          # https://console.aws.amazon.com/elastictranscoder/home?region=us-west-2#preset-details:1351620000001-200055
          # System preset: HLS Video - 400k
          preset_id: '1351620000001-200055',
          segment_duration: "10"
        },
        {
          key: "hls_audio_64k",
          # https://console.aws.amazon.com/elastictranscoder/home?region=us-west-2#preset-details:1351620000001-200071
          # System preset: HLS Audio - 64k
          preset_id: '1351620000001-200071',
          segment_duration: "10"
        },
      ],
      playlists: [
        {
          name: "index",
          format: "HLSv4",
          output_keys: ["hls_video_400k", "hls_audio_64k"]
        }
      ],
      # TODO: should use another, new UUID for this? Should use another table/row/record for submitting to Elastic Transcode, to handle resubmits/retranscodes/failures/retries?
      output_key_prefix: "hlsv4/#{uuid}/"
    }

    job = transcoder.create_job(options)

    # STATUS_SUBMITTED =  "Submitted"
    # STATUS_PROGRESSING =  "Progressing"
    # STATUS_COMPLETE =  "Complete"
    # STATUS_CANCELED =  "Canceled"
    # STATUS_ERROR =  "Error"
    #
    # On Progressing Event
    # On Warning Event
    # On Completion Event
    # On Error Event
    #
    # Example response:
    #
    # {:id=>"1464568658231-44vnuh",
    #  :arn=>
    #   "arn:aws:elastictranscoder:us-west-2:784245509715:job/1464568658231-44vnuh",
    #  :pipeline_id=>"1464551986249-lqqtib",
    #  :input=>{:key=>"uploads/ed05c287-fc99-4504-8e1e-bc710627700d"},
    #  :output=>
    #   {:id=>"1",
    #    :key=>"hls_video_400k",
    #    :preset_id=>"1351620000001-200055",
    #    :segment_duration=>"10.0",
    #    :status=>"Submitted",
    #    :watermarks=>[]},
    #  :outputs=>
    #   [{:id=>"1",
    #     :key=>"hls_video_400k",
    #     :preset_id=>"1351620000001-200055",
    #     :segment_duration=>"10.0",
    #     :status=>"Submitted",
    #     :watermarks=>[]},
    #    {:id=>"2",
    #     :key=>"hls_audio_64k",
    #     :preset_id=>"1351620000001-200071",
    #     :segment_duration=>"10.0",
    #     :status=>"Submitted",
    #     :watermarks=>[]}],
    #  :output_key_prefix=>"hlsv4/ed05c287-fc99-4504-8e1e-bc710627700d/",
    #  :playlists=>
    #   [{:name=>"index",
    #     :format=>"HLSv4",
    #     :output_keys=>["hls_video_400k", "hls_audio_64k"],
    #     :status=>"Submitted"}],
    #  :status=>"Submitted",
    #  :timing=>{:submit_time_millis=>1464568658258}}
    self.transcoder_job_id = job.data[:job][:id]
    self.transcoder_job_data = job.data[:job].to_h
  end
end

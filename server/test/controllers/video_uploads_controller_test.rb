require 'test_helper'

class VideoUploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @video_upload = video_uploads(:one)
  end

  test "should get index" do
    get video_uploads_url
    assert_response :success
  end

  test "should create video_upload" do
    assert_difference('VideoUpload.count') do
      post video_uploads_url, params: { video_upload: {  } }
    end

    assert_response 201
  end

  test "should show video_upload" do
    get video_upload_url(@video_upload)
    assert_response :success
  end

  test "should update video_upload" do
    patch video_upload_url(@video_upload), params: { video_upload: {  } }
    assert_response 200
  end

  test "should destroy video_upload" do
    assert_difference('VideoUpload.count', -1) do
      delete video_upload_url(@video_upload)
    end

    assert_response 204
  end
end

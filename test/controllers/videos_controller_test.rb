require 'test_helper'

class VideosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @video = videos(:one)
  end

  test "should get index" do
    get videos_url
    assert_response :success
  end

  test "should create video" do
    assert_difference('Video.count') do
      post videos_url, params: { video: { path: @video.path, title: @video.title, url: @video.url } }
    end

    assert_response 201
  end

  test "should show video" do
    get video_url(@video)
    assert_response :success
  end

  test "should update video" do
    patch video_url(@video), params: { video: { path: @video.path, title: @video.title, url: @video.url } }
    assert_response 200
  end

  test "should destroy video" do
    assert_difference('Video.count', -1) do
      delete video_url(@video)
    end

    assert_response 204
  end
end

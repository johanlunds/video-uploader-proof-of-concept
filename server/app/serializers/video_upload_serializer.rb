class VideoUploadSerializer < ActiveModel::Serializer
  attributes :uuid, :presigned_post
end

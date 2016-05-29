class VideoUploadSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :presigned_post, :status
end

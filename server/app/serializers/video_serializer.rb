class VideoSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :url
end

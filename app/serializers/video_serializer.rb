class VideoSerializer < ActiveModel::Serializer
  attributes :id, :title, :path, :url
end

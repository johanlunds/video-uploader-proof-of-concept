class Video < ApplicationRecord
  belongs_to :video_upload

  include Workflow

  workflow_column :status
  workflow do
    state :new do
      event :publish, transitions_to: :published
    end
    state :published
  end
end

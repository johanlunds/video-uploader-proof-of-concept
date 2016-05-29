class Video < ApplicationRecord
  belongs_to :video_upload

  include Workflow

  workflow_column :status
  workflow do
    state :new do
      event :process, transitions_to: :processing
    end
    state :processing do
      event :processed, transitions_to: :published
    end
    state :published
  end
end

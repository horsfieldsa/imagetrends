class Sneaker < ApplicationRecord
  has_many :likes, dependent: :delete_all
  has_many :tags, dependent: :delete_all
  has_one_attached :sneaker_image
  belongs_to :user

  after_create_commit :detect_labels

  # Pagination Items Per Page
  self.per_page = 36
  
  private
  def detect_labels
    DetectLabelsJob.perform_async(self.id)
    DetectModerationLabelsJob.perform_async(self.id)
    DetectTextJob.perform_async(self.id)
    DetectCelebritiesJob.perform_async(self.id)
  end

end
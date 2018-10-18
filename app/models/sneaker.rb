class Sneaker < ApplicationRecord
  has_many :tags, dependent: :delete_all
  has_one_attached :sneaker_image
  belongs_to :user
  has_many :favorites

  after_create_commit :detect_labels

  # Pagination Items Per Page
  self.per_page = 20
  
  private
  def detect_labels
    DetectLabelsJob.perform_async(self.id)
    DetectModerationLabelsJob.perform_async(self.id)
    DetectTextJob.perform_async(self.id)
    DetectCelebritiesJob.perform_async(self.id)
    DetectExifDataJob.perform_async(self.id)
    #DetectFaceDetailsJob.perform_async(self.id)
  end

end
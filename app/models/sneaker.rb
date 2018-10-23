class Sneaker < ApplicationRecord

  has_many :tags, dependent: :delete_all
  has_many :favorites, dependent: :delete_all
  has_one_attached :sneaker_image
  belongs_to :user

  after_create_commit :detect_labels, :log_create
  after_update_commit :log_update
  after_destroy_commit :log_destroy

  # Pagination Items Per Page
  self.per_page = 20
  
  private
  def detect_labels
    DetectLabelsJob.perform_async(self.id)
    DetectModerationLabelsJob.perform_async(self.id)
    DetectTextJob.perform_async(self.id)
    DetectCelebritiesJob.perform_async(self.id)
    DetectExifDataJob.perform_async(self.id)
  end

  private

  def log_create
    sneaker_logger.info("Image created: User: #{self.user.username} Image: #{self.id} ")
  end

  def log_update
    sneaker_logger.info("Image updated: User: #{self.user.username} Image: #{self.id} ")
  end

  def log_destroy
    sneaker_logger.info("Image deleted: User: #{self.user.username} Image: #{self.id} ")
  end

  def sneaker_logger
    @@sneaker_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end
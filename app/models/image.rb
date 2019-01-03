class Image < ApplicationRecord

  has_many :tags, dependent: :delete_all
  has_many :events, dependent: :delete_all
  has_many :favorites, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_one_attached :image_image
  belongs_to :user

  after_create_commit :detect_labels, :log_create, :publish_event
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

  def publish_event

    @event = Event.new do |e|
        e.message = "#{self.user.username} uploaded a new image."
        e.image_id = self.id
        e.user_id = self.user.id
    end

    @event.save

  end

  def log_create
    image_logger.info("Image created: User: #{self.user.username} Image: #{self.id} ")
  end

  def log_update
    image_logger.info("Image updated: User: #{self.user.username} Image: #{self.id} ")
  end

  def log_destroy
    image_logger.info("Image deleted: User: #{self.user.username} Image: #{self.id} ")
  end

  def image_logger
    @@image_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end
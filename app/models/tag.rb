class Tag < ApplicationRecord
  belongs_to :image

  after_create_commit :log_create
  after_update_commit :log_update
  after_destroy_commit :log_destroy

  private

  def log_create
    tag_logger.info("Tag created: Name: #{self.name} Image: #{self.image.id} ")
  end

  def log_update
    tag_logger.info("Tag updated: Name: #{self.name} Image: #{self.image.id} ")
  end

  def log_destroy
    tag_logger.info("Tag deleted: Name: #{self.name} Image: #{self.image.id} ")
  end    

  def tag_logger
    @@tag_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end

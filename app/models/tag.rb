class Tag < ApplicationRecord
  belongs_to :sneaker

  after_create_commit :log_creation

  private

  def log_creation
    tag_logger.info("Tag created: Name: #{self.name} Image: #{self.sneaker.id} ")
  end

  def tag_logger
    @@tag_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end

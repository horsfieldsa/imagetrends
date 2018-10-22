class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :sneaker

    after_create_commit :log_creation

    private

    def log_creation
        favorite_logger.info("Image favorited: User: #{self.user.username} Image: #{self.sneaker.id} ")
    end
  
    def favorite_logger
      @@favorite_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end

class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :image

    after_create_commit :log_create, :publish_event
    after_update_commit :log_update
    after_destroy_commit :log_destroy

    private

    def publish_event

        @event = Event.new do |e|
            e.message = "#{self.user.username} favorited an image."
            e.image_id = self.image.id
            e.user_id = self.user.id
        end

        @event.save
    
    end

    def log_create
        favorite_logger.info("Favorite created: User: #{self.user.username} Image: #{self.image.id} ")
    end
  
    def log_update
        favorite_logger.info("Favorite updated: User: #{self.user.username} Image: #{self.image.id} ")
    end

    def log_destroy
        favorite_logger.info("Favorite deleted: User: #{self.user.username} Image: #{self.image.id} ")
    end

    def favorite_logger
      @@favorite_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end

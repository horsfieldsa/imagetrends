class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :image

    after_create_commit :log_create, :publish_event, :record_event
    after_update_commit :log_update
    after_destroy_commit :log_destroy

    private

    # Record Event For Personalize
    def record_event

        @category = Tag.where(image_id: self.image.id).where("confidence > ?", 95.0).first!

        event = {
            type: 'useritem',
            ITEM_ID: self.image.id,
            USER_ID: self.user.id,
            EVENT_TYPE: 'like',
            EVENT_VALUE: self.id,
            TIMESTAMP: Time.now.to_i,
            CATEGORY: @category ? @category.name : 'None'
        }

        EventRecordJob.perform_async(event)
    end

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

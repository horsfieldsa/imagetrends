class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :image

    validates :comment, presence: true
    validates_length_of :comment, :minimum => 10, :maximum => 500 

    after_create_commit :detect_sentiment, :log_create, :publish_event
    after_update_commit :log_update
    after_destroy_commit :log_destroy

    private  

    def publish_event

        @event = Event.new do |e|
            e.message = "#{self.user.username} added a comment."
            e.image_id = self.image.id
            e.user_id = self.user.id
            e.comment_id = self.id
        end

        @event.save
    
    end

    def detect_sentiment
        DetectSentimentJob.perform_async(self.id)
    end

    def log_create
        comment_logger.info("Comment created: User: #{self.user.username} Image: #{self.image.id} ")
    end
  
    def log_update
        comment_logger.info("Comment updated: User: #{self.user.username} Image: #{self.image.id} ")
    end

    def log_destroy
        comment_logger.info("Comment deleted: User: #{self.user.username} Image: #{self.image.id} ")
    end

    def comment_logger
      @@comment_logger ||= Logger.new("#{Rails.root}/log/application.log")
    end

end

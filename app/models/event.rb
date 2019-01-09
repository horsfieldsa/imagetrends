class Event < ApplicationRecord
    belongs_to :image
    belongs_to :user
    
    after_create_commit { EventBroadcastJob.perform_async(self) }

    # Pagination Items Per Page
    self.per_page = 10

    private
    
end
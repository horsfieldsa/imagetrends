class Event < ApplicationRecord
    belongs_to :image
    belongs_to :user
    belongs_to :comment
    
    after_create_commit { EventBroadcastJob.perform_async(self) }

    # Pagination Items Per Page
    self.per_page = 20
end
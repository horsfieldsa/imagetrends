class AddCommentIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :comment_id, :integer
  end
end

class AddUserIdToSneakers < ActiveRecord::Migration[5.2]
  def change
    add_column :sneakers, :user_id, :integer
  end
end

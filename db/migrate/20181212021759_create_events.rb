class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :message
      t.integer :image_id
      t.integer :user_id

      t.timestamps
    end
  end
end

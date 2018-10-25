class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :image_id
      t.integer :user_id
      t.text :comment
      t.string :sentiment

      t.timestamps
    end
  end
end

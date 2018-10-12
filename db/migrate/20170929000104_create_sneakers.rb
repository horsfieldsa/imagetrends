class CreateSneakers < ActiveRecord::Migration[5.0]
  def change
    create_table :sneakers do |t|
      t.string :image_url

      t.timestamps
    end
  end
end

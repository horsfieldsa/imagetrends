class AddApprovedToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :approved, :boolean
  end
end

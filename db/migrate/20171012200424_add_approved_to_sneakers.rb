class AddApprovedToSneakers < ActiveRecord::Migration[5.0]
  def change
    add_column :sneakers, :approved, :bool
  end
end

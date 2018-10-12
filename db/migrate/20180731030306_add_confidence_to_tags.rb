class AddConfidenceToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :confidence, :float
  end
end

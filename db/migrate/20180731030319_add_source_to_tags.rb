class AddSourceToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :source, :string
  end
end

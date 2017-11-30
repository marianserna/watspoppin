class ChangeHashtagNameToUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :hashtags, :name, :unique => true
  end
end

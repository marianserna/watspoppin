class CreateStories < ActiveRecord::Migration[5.1]
  def change
    create_table :stories do |t|
      t.string :user_id
      t.text :content
      t.string :source
      t.string :image
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end

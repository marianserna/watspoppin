class CreateStoryTagsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :hashtags_stories do |t|
      t.belongs_to :hashtag
      t.belongs_to :story
    end
  end
end

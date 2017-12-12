class RenamePostsIdToStoriesIdInLikes < ActiveRecord::Migration[5.1]
  def change
    rename_column :likes, :post_id, :story_id
  end
end

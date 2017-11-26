class AddUidAndHandleToStories < ActiveRecord::Migration[5.1]
  def change
     add_column :stories, :uid, :string
     add_column :stories, :handle, :string

     add_index :stories, :uid
  end
end

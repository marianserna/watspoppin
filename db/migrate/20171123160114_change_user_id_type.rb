class ChangeUserIdType < ActiveRecord::Migration[5.1]
  def change
    remove_column :stories, :user_id
    add_column :stories, :user_id, :integer
  end
end

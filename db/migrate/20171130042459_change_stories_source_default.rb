class ChangeStoriesSourceDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :stories, :source, :string, :default => "watspoppin"
  end
end

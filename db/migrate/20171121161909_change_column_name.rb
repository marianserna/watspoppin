class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :stories, :lattitude, :latitude
  end
end

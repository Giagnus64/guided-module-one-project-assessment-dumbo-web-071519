class Addcolumnnametodungeon < ActiveRecord::Migration[5.2]
  
  def change
    add_column :dungeons, :name, :string
  end
end

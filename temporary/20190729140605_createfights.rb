class CreateFights < ActiveRecord::Migration[5.2]
  
  def change
   create_table :fights do |table|
    table.integer :hero_id
    table.integer :monster_id
    table.integer :dungeon_id
    table.string :winner
    table.boolean :happened
   end
  end
end

class Createdungeons < ActiveRecord::Migration[5.2]
  def change
    create_table :dungeons do |table|
      table.string :level
      table.string :description
    end
  end
end

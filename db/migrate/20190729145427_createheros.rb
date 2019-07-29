class Createheros < ActiveRecord::Migration[5.2]
  def change
    create_table :heros do |table|
     table.string :name
     table.integer :strength
     table.string :victory_chant
     table.string :defeat_chant
     table.string :attack_chant
     table.string :email
    end
  end
end



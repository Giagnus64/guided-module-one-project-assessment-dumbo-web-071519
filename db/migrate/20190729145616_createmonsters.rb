class Createmonsters < ActiveRecord::Migration[5.2]
  def change
    create_table :monsters do |table|
      table.string :name
      table.integer :strength
      table.string :attack_noise
      table.string :defeat_noise
      table.string :victory_noise
    end
  end
end

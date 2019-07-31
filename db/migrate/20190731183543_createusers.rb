class Createusers < ActiveRecord::Migration[5.2]
  
  def change
    create_table :users do |table|
      table.string :name
      table.string :email
    end
  end

end

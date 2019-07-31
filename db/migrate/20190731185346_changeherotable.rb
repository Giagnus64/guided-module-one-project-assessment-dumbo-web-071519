class Changeherotable < ActiveRecord::Migration[5.2]
  
  def change
      remove_column :heros, :email, :string
      add_column :heros, :user_id, :integer
  end


end

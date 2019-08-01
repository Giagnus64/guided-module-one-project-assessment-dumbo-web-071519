class Addchilisstatustoheros < ActiveRecord::Migration[5.2]
  
  def change
    add_column :heros, :chilis_status, :boolean
  end

end

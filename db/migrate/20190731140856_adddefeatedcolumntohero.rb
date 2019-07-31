class Adddefeatedcolumntohero < ActiveRecord::Migration[5.2]
  
  def change
    add_column :heros, :times_defeated, :integer
  end

end

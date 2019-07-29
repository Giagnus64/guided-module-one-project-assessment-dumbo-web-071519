class Fight < ActiveRecord::Base 
    belongs_to :hero
    belongs_to :monster
    belongs_to :dungeon
end
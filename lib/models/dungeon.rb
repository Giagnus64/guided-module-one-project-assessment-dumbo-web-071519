class Dungeon < ActiveRecord::Base
    has_many :fights
    has_many :heros, through: :fights
    has_many :monsters, through: :fights
end
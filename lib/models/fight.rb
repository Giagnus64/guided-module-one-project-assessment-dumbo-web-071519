class Fight < ActiveRecord::Base 
    belongs_to :hero
    belongs_to :monster
    belongs_to :dungeon

    #creates and returns a fight when passed the proper arguments
    def self.seed_fight(hero, monster, dungeon)
        Fight.create({
            hero_id: hero.id,
            monster_id: monster.id, 
            dungeon_id: dungeon.id, 
            happened: false
        })
    end
end
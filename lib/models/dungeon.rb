class Dungeon < ActiveRecord::Base
    has_many :fights
    has_many :heros, through: :fights
    has_many :monsters, through: :fights

    def self.dungeons_by_hero(hero)
        self.all.select {|dungeon| dungeon.heros.include?(hero)}
    end

    def self.seed_dungeon(level, hero)
        #create dungeon instance
        dung = Dungeon.create ({
            name: self.get_name,
            description: self.get_description,
            level: level
        })
        #create monsters
        #pass dungeon instance to each fight
        3.times do
            mon = Monster.generate_monster(level)
            Fight.seed_fight(hero, mon, dung)
        end
    end
    
    #returns a random description
    def self.get_description
        descs = ["This place sucks.", "Abandon all hope, ye who enter here.", "Welcome to Chili's.", "Don't Enter Dead Inside", "Explored by Scooby-Doo circa 1964"]
        descs[rand(descs.count)]
    end
    # returns a random name
    def self.get_name
        names = ["Pharaoh's Tomb", "Catacombs", "Screeching Sawmill", "Shadow Tower", "Flooded Basement", "Chili's", "House of Doom", "Crumbling Attic", "Ancient Mausoleum",  "Abandoned Sewers", "Mangled Cages", "Corpse Vault"]
        names[rand(names.count)]
    end
end
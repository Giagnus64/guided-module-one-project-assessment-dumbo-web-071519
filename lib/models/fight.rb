class Fight < ActiveRecord::Base 
    belongs_to :hero
    belongs_to :monster
    belongs_to :dungeon

    def self.prompt
        TTY::Prompt.new
    end

    #creates and returns a fight when passed the proper arguments
    def self.seed_fight(hero, monster, dungeon)
        Fight.create({
            hero_id: hero.id,
            monster_id: monster.id, 
            dungeon_id: dungeon.id, 
            happened: false
        })
    end

    def simulate_fight
        self.happened = true
        attacks = self.roll_attacks
        # if hero_attack is greaterthan or equal to monster attack
        if attacks[0] >= attacks[1]
            self.winner = self.hero.name
            self.hero.strength += 1
            puts ""
            Fight.prompt.keypress("#{self.monster.name} is DEFEATED ☠️  ☠️  ☠️  ☠️  ☠️!", timeout: 3)
            Fight.prompt.keypress("#{self.hero.name}: '#{self.hero.victory_chant}!'", timeout: 3)
            Fight.prompt.keypress("#{self.monster.name}: '#{self.monster.defeat_noise}!'", timeout: 3)
        else 
            self.winner = self.monster.name
            Fight.prompt.keypress("#{self.hero.name} is DEFEATED ☠️  ☠️  ☠️  ☠️  ☠️!", timeout: 3)
            Fight.prompt.keypress("#{self.monster.name}: '#{self.monster.victory_noise}!'", timeout: 3)
            Fight.prompt.keypress("#{self.hero.name}: '#{self.hero.defeat_chant}!'" + "\n", timeout: 3)
        end
        #save instances
        self.save
        self.hero.save
        menu_outcome = self.dungeon.id
    end

    def roll_attacks
        attacks = []
        hero_attack = self.hero.strength + rand(20)
        attacks.push(hero_attack)
        monster_attack = self.monster.strength + rand(20)
        attacks.push(monster_attack)
        Fight.prompt.keypress("" + "\n" + "#{self.hero.name} attacks with a power level of #{hero_attack}!" + "\n" + "#{self.hero.name}: '#{self.hero.attack_chant}!'", timeout: 3) 
        Fight.prompt.keypress("" + "\n" + "🗡️  🗡️  🗡️  🗡️  🗡️" + "\n", timeout: 3)
        Fight.prompt.keypress("#{self.monster.name} attacks with a power level of #{monster_attack}!" + "\n" + "#{self.monster.name}: '#{self.monster.attack_noise}!'", timeout: 3)
        Fight.prompt.keypress("" + "\n" + "👊  👊  👊  👊  👊", timeout: 3)
        attacks
    end

end
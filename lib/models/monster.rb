class Monster < ActiveRecord::Base 
    has_many :fights
    has_many :heros, through: :fights

    # pulls monster names from the API and puts them into a class variable
    def self.get_monster_names
        response = RestClient.get("http://dnd5eapi.co/api/monsters/")
        parsed = JSON.parse(response)
        monster_names = parsed["results"].map{|monster_hash| monster_hash["name"]}
        @@monster_names = monster_names
    end

    #returns class variable of APi-pulled names
    def self.monster_names
        @@monster_names
    end

    #gets a random name from the list of monster names
    def self.random_monster_name
        self.monster_names[rand(self.monster_names.count)]
    end

    #determines a monster's stats through helper methods, and assigns them to a new monster
    def self.generate_monster(level)
        # gets str mod by level
        str_mod = self.determine_difficulty(level)

        Monster.create({
            name: self.random_monster_name, 
            strength: rand(str_mod), 
            victory_noise: self.get_victory_noise,
            attack_noise: self.get_attack_noise,
            defeat_noise: self.get_defeat_noise
        })
    end

    #passes difficulty modifier based on level input
    def self.determine_difficulty(level)
        case level
            when "easy"
                str_mod = 1..10
            when "medium"
                str_mod = 5..15
            when "hard"
                str_mod = 10..20
        end
        str_mod
    end

    #generates a random attack noise
    def self.get_attack_noise
        noises = ["Have at you!", "RAWR!", "slurp slurp", "You want a knuckle sandwich?!", "Your ass is grass!", "Aaaaaeeeggghhhhaaaaahhhhh"]
        noises.sample
    end

    #generates a random attack noise
    def self.get_defeat_noise
        noises = ["NOOOOOOOO", "SPLAT!", "I don't like you", "You will pay for this!", "This ain't over, buddy!"]
        noises.sample
    end

    # generates a random victory noise
    def self.get_victory_noise
        noises = ["ROAAAAAAAAR", "Take that, pesky adventurer!", "Welcome to Chili's!", "I hope you've learned your lesson, swine!", "That was fun. Let's do this again some day!"]
        noises.sample
    end
    
end
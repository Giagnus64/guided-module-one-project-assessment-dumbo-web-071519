class Hero < ActiveRecord::Base 
    has_many :fights
    has_many :monsters, through: :fights
    has_many :dungeons, through: :fights

    def self.prompt
        TTY::Prompt.new
    end


    def self.get_hero_names
        #calls the smash api to get character hashes
        response = RestClient.get("http://smashlounge.com/api/chars/all")
        #parsed the response into JSON
        parsed = JSON.parse(response)
        #pulls an array of character names out of JSON
        names = parsed.map{|character_hash| character_hash["name"]}
        names
    end

    def self.handle_new_adventurer
       puts "A new challenger approaches! Let's see if you are any good!"
    #    puts "Enter your email address - (this will be used for login purposes only)."
    #    email = gets.chomp
       # asks for email and validates using TTY PROMPT
       email = self.prompt.ask("Enter your email address - (this will be used for login purposes only).") { |q| q.validate :email } 
       #gives selection choices through TTY PROMPT
       selection_choice = self.prompt.select('What is thy name, Hero?', {"Use my own name": 1, "Choose from a list of adventurer names": 2})
       # handles name input choice
       adventurer_name = self.name_handler(selection_choice)
       adventurer_chants = self.ask_for_battle_chants
     #creates new hero with variables provided
       Hero.create({
           name: adventurer_name, 
           email: email, 
           victory_chant: adventurer_chants["victory_chant"], 
           attack_chant: adventurer_chants["attack_chant"],
           defeat_chant: adventurer_chants["defeat_chant"],
           strength: rand(20)   
        })
        binding.pry
    end
    #handles name_input choice
    def self.name_handler(adventurer_choice)
        case adventurer_choice
            when 1
                hero_name = self.prompt.ask("Enter your name please.")
            when 2
                hero_name = self.prompt.select("Select your name please.", self.get_hero_names)
        end

        return hero_name
    end
    # checks and logs in returning adventurer, loops if any error is preset
    def self.handle_returning_adventurer(string)
         puts string
         email = self.prompt.ask("Enter your email address.") { |q| q.validate :email }
         heros = self.all.select {|user| user.email == email }
         if heros.length == 0
            self.handle_returning_adventurer("There's no hero with that email! Please re-enter your email!")
         else 
            return heros[0]
         end
    end
    #asks user to input battle chants
    def self.ask_for_battle_chants
        chants = {}
        puts "What is your attack chant?"
        chants["attack_chant"] = gets.chomp
        puts "What is your victory chant?"
        chants["victory_chant"] = gets.chomp
        puts "What is your defeat chant?"
        chants["defeat_chant"]= gets.chomp
        return chants
	end
		
	def check_stats
		number_of_fights = (self.fights.any?) ? self.fights.count : "No monsters have been fought."
		system "clear"
		puts "These are your stats #{self.name}"
		puts "================="
		puts "Strength: #{self.strength}\nAttack Chant: #{self.attack_chant}\nVictory Chant: #{self.victory_chant}\nDefeat Chant: #{self.defeat_chant}\nMonster Defeated: #{number_of_fights}"
		Hero.prompt.select("What would you like to do?") do |menu|
			menu.choice "Change name or chants", -> {self.change_stats_prompt}
			menu.choice "Go back to Main Menu", -> {"main_menu"}
		end
	end

	def change_stats_prompt
		Hero.prompt.select("What would you like to change?") do |menu|
			menu.choice "Name", -> {self.change_stats(:name)}
			menu.choice "Attack chant", -> {self.change_stats(:attack_chant)}
			menu.choice "Victory chant", -> {self.change_stats(:victory_chant)}
			menu.choice "Defeat chant", -> {self.change_stats(:defeat_chant)}
		end
	end

	def change_stats(key)
		puts "What would you like to change this to?"
		changed_stats = gets.chomp
		self[key] = changed_stats
		self.save()
		system "clear"
		Hero.prompt.keypress("Your adventurer has been updated! Returning to main menu automatically in 5 seconds ...", timeout: 5)
		return "main_menu"
	end

    def self.delete_hero(hero_instance)
        
        delete_choice = self.prompt.select("Oh adventurer, it is a shame to see you perish. Are you sure?", {"Yes": 1, "No": 2 })
        outcome = self.hero_delete_choice(delete_choice, hero_instance)
    end

    def self.hero_delete_choice(delete_choice, hero_instance)
        case delete_choice
        when 1
            #delete this hero
            hero_instance.destroy
            #next step: return to welcome interface
            return "exit"
        when 2
            puts "That's it, you champion. Keep fighting!"
            return "main_menu"
        end
         
    end

end
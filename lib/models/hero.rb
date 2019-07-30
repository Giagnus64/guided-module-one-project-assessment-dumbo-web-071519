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
end
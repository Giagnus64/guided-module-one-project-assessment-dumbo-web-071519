class Hero < ActiveRecord::Base 
    has_many :fights
    has_many :monsters, through: :fights
    has_many :dungeons, through: :fights
    belongs_to :user

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

    def self.make_new_hero(user)
       puts "A new challenger approaches! Let's see if you are any good!"
       #gives selection choices through TTY PROMPT
       selection_choice = self.prompt.select('What is thy name, Hero?', {"Use my own name": 1, "Choose from a list of hero names": 2})
       # handles name input choice
       hero_name = self.name_handler(selection_choice)
       hero_chants = self.ask_for_battle_chants
     #creates new hero with variables provided
       Hero.create({
           name: hero_name,  
           victory_chant: hero_chants["victory_chant"], 
           attack_chant: hero_chants["attack_chant"],
           defeat_chant: hero_chants["defeat_chant"],
           strength: rand(1..20), 
           times_defeated: 0, 
           user_id: user.id   
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
        fights_won = self.fights.select{|fight| fight.happened && fight.winner == self.name}
		number_of_fights = (fights_won.any?) ? fights_won.count : "No monsters have been defeated."
		system "clear"
		puts "These are your stats #{self.name}"
		puts "================="
		puts "Strength: #{self.strength}\nAttack Chant: #{self.attack_chant}\nVictory Chant: #{self.victory_chant}\nDefeat Chant: #{self.defeat_chant}\nMonsters Defeated: #{number_of_fights}"
		Hero.prompt.select("What would you like to do?") do |menu|
            menu.choice "Change Name or Chants", -> {self.change_stats_prompt}
            menu.choice "Check Monsters Defeated", -> {self.display_monster_table}
			menu.choice "Go back to Main Menu", -> {"main_menu"}
		end
	end

	def change_stats_prompt
		Hero.prompt.select("What would you like to change?") do |menu|
			menu.choice "Name", -> {self.change_stats(:name)}
			menu.choice "Attack chant", -> {self.change_stats(:attack_chant)}
            menu.choice "Victory chant", -> {self.change_stats(:victory_chant)}
            menu.choice "Defeat chant", -> {self.change_stats(:defeat_chant)}
			menu.choice "Go back to Stats Menu", -> {self.check_stats}
        end
    end

    def change_stats(key)
		puts "What would you like to change this to?"
		changed_stats = gets.chomp
		self[key] = changed_stats
		self.save()
		system "clear"
		Hero.prompt.keypress("Your adventurer has been updated! Returning to stats menu automatically in 3 seconds ...", timeout: 3)
		self.check_stats
    end

    def self.delete_hero(hero_instance)
        delete_choice = self.prompt.select("Oh adventurer, it is a shame to see you perish. Are you sure?", {"Yes": 1, "No": 2 })
        outcome = self.hero_delete_choice(delete_choice, hero_instance)
    end

    def self.hero_delete_choice(delete_choice, hero_instance)
        case delete_choice
        when 1
            
            hero_instance.fights.destroy_all
            hero_instance.dungeons.destroy_all
            hero_instance.destroy
            self.prompt.keypress("Goodbye hero! You will be forgotten...", timeout: 3)
            return "change_hero"
        when 2
            Hero.prompt.keypress("That's it, you champion. Keep fighting!", timeout: 3)
            return "main_menu"
        end
    end

    def self.display_leaderboard
       ratio_arrays = self.get_ratio_arrays
       headings = ["Place", "User", "Name", "Strength", "Monsters Defeated", "Total Fights", "Win/Loss Ratio"]
       table = Terminal::Table.new :title => "Adventurer Leaderboard", :headings => headings, :rows => ratio_arrays
        
        #aligns table columns
        table.align_column(0, :center)
        table.align_column(1, :center)
        table.align_column(2, :center)
        table.align_column(3, :center)
        table.align_column(4, :center)
        table.align_column(5, :center)
        table.align_column(6, :center)

       puts table
       Hero.prompt.select("") do |menu|
			menu.choice "Go back to Main Menu", -> {"main_menu"}
		end
    end

    def self.get_ratio_arrays
       ratio_hash = self.all.reduce({}) {|hash, hero| hash.update(hero => hero.get_win_loss_ratio.round(3))}
       sorted = ratio_hash.sort_by(&:last).reverse
       arrays = sorted.map {|ratio_arr| 
        arr = [
            sorted.index(ratio_arr) + 1,
            ratio_arr[0].user.name,
            ratio_arr[0].name,
            ratio_arr[0].strength, 
            ratio_arr[0].monsters_defeated.count, 
            ratio_arr[0].get_total_fights,
            ratio_arr[1]
        ]}
    end

    def get_win_loss_ratio
        if self.times_defeated == 0
            ratio = self.monsters_defeated.count
        else 
            ratio = self.monsters_defeated.count.to_f / self.get_total_fights.to_f
        end
    end

    def get_total_fights
        self.times_defeated + self.monsters_defeated.count
    end

    def monsters_defeated
        fights_won = self.fights.select{|fight| fight.winner == self.name}
    end

    def display_monster_table
        rows = self.monsters_defeated.map{|fight| arr =
            fight.monster.name, 
            fight.monster.strength, 
            fight.dungeon.name, 
            fight.monster.defeat_noise 
        }
        headings = ["Monster Name", "Strength", "Dungeon", "Last Words"]
        table = Terminal::Table.new :title => "Monsters Defeated", :headings => headings, :rows => rows
        table.align_column(0, :center)
        table.align_column(1, :center)
        table.align_column(2, :center)
        table.align_column(3, :center)
        puts table
        Hero.prompt.select("") do |menu|
			menu.choice "Go back to Stats Menu", -> {self.check_stats}
		end
    end
end
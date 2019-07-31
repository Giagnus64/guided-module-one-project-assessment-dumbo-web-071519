class Interface

    attr_accessor :prompt, :hero

    def initialize()
        @prompt = TTY::Prompt.new
    end

    # gets hero instance via hero helper methods
    def welcome
        system "clear"
        puts "Welcome to Dungeon Crawler!"
        answer = self.prompt.select("Have you been here before?") do |menu|
            menu.choice "New Adventurer", -> {Hero.handle_new_adventurer}
            menu.choice "Returning Adventurer", -> {Hero.handle_returning_adventurer("Ah! Coming back for more, eh? Identify yourself!")}
        end
    end

    def main_menu
        hero.reload
        system "clear"
        puts "============================\nWelcome #{self.hero.name}!\t Strength: #{self.hero.strength}\n============================"
        answer = self.prompt.select("What do you want to do today?") do |menu|
            menu.choice "Enter Dungeon", -> {Dungeon.check_dungeons(self.hero)}
            menu.choice "Check/Update Stats", -> {self.hero.check_stats}
            menu.choice "Check Leaderboard", -> {Hero.display_leaderboard}
            menu.choice "Delete Adventurer", -> {Hero.delete_hero(self.hero)}
            menu.choice "Exit Program", -> {"exit"}
        end
    end
    
    def dungeon_menu
        system "clear"
        #populate dungeon list
        dungeon_list = Dungeon.dungeons_by_hero(self.hero)
        # makes a new hash and sets the dungeon's string name and difficulty to the value of the dungeon id
        dungeon_hash = dungeon_list.each_with_object({}) {|dungeon, hash| hash["#{dungeon.name} - #{dungeon.level.capitalize}"] = dungeon.id}
        #makes an option to exit to main menu
        dungeon_hash["Exit to Main Menu"] = "main_menu"
        system "clear"
        answer = self.prompt.select("Which dungeon would you like to enter?", dungeon_hash)
    end

    def inside_dungeon(dungeon_id)
        dung = Dungeon.find(dungeon_id)
        choice_hash = {}
        self.prompt.keypress("====================" + "\n" + "You are in #{dung.name}!" + "\n" + "#{dung.description}", timeout: 2)
        self.prompt.keypress("" + "\n" + "There are #{dung.fights_left.count} monsters left in this dungeon." + "\n" + " ", timeout: 2)
        if dung.fights_left.count !=0
            # puts monster names and levels into a hash for choices, returns fight instance
            choice_hash = dung.fights_left.each_with_object({}){|fight, hash| hash["Fight #{fight.monster.name}: Strength - #{fight.monster.strength}"] = fight}
        end
        #adds option to exit menu
        choice_hash["Leave Dungeon"] = "dungeon_menu"
        # asks user to fight a monster or exit the menu
        fight_choice = self.prompt.select("What would you like to do?", choice_hash)
        #checks if the user wants to exit or fight a monster
        # if the user wants to fight, the method simulates a fight and returns a menu choice
        check_dungeon_choice(fight_choice)
    end

    def check_dungeon_choice(fight_choice)
        if fight_choice == "dungeon_menu"
            return "dungeon_menu"
        else 
           fight_choice.simulate_fight 
        end
    end


end
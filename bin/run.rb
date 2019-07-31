require_relative '../config/environment'

#starts a new interface instance
cli = Interface.new
#calls the Monster API once to store monster names list in Monster class
monster_names = Monster.get_monster_names
#gets the user instance via help methods in the instance and user classes
hero_instance = cli.welcome
#assigns the user instance to the interface instance
if hero_instance == "logout"
    exit(0)
end
cli.hero = hero_instance
#gives the main_menu instance
next_interface = cli.main_menu

while next_interface != "exit"
    case next_interface 
        when "main_menu"
            #calls the main menu
            next_interface = cli.main_menu
        when "dungeon_menu"
            #calls to the dungeon menu
            next_interface = cli.dungeon_menu
        when Integer
            # goes inside that dungeon number
            next_interface = cli.inside_dungeon(next_interface)
        when "change_hero"
            # asks the user to select a new hero, and 
            hero_instance = cli.select_hero
            if hero_instance == "logout"
                exit(0)
            end
            cli.hero = hero_instance
            next_interface = main_menu
    end
end





#binding.pry
puts "Goodbye!"

require_relative '../config/environment'

#starts a new interface instance
cli = Interface.new
#calls the Monster API once to store monster names list in Monster class
monster_names = Monster.get_monster_names
#gets the hero instance via help methods in the instance and hero classes
hero_instance = cli.welcome
#assigns the hero instance to the interface instance
cli.hero = hero_instance
#gives the main_menu instance
next_interface = cli.main_menu

while next_interface != "exit"
    case next_interface 
        when "main_menu"
            next_interface = cli.main_menu
        when "dungeon_menu"
            next_interface = cli.dungeon_menu
        when Integer
            next_interface = cli.inside_dungeon(next_interface)
    end
    #binding.pry
end





#binding.pry
puts "Goodbye!"

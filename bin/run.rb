require_relative '../config/environment'

#starts a new interface instance
cli = Interface.new
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
    end
end




binding.pry
puts "hello world"

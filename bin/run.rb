require_relative '../config/environment'

#starts a new interface instance
cli = Interface.new
#gets the hero instance via help methods in the instance and hero classes
hero_instance = cli.welcome
#assigns the hero instance to the interface instance
cli.hero = hero_instance
#gives the main_menu instance
cli.main_menu


binding.pry
puts "hello world"

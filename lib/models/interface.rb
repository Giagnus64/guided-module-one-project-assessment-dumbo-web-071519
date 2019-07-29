class Interface

    attr_accessor :prompt, :hero

    def initialize()
        @prompt = TTY::Prompt.new
    end
    
    def welcome
        puts "Welcome to Dungeon Crawler!"
        answer = prompt.select("Have you been here before?") do |menu|
            menu.choice "New Adventurer", -> {Hero.handle_new_adventurer}
            menu.choice "Returning Adventurer", -> {Hero.handle_returning_adventurer}
        end
    end
end
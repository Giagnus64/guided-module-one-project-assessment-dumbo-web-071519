class Interface

    attr_accessor :prompt, :hero

    def initialize()
        @prompt = TTY::Prompt.new
    end

    # gets hero instance via hero helper methods
    def welcome
        puts "Welcome to Dungeon Crawler!"
        answer = prompt.select("Have you been here before?") do |menu|
            menu.choice "New Adventurer", -> {Hero.handle_new_adventurer}
            menu.choice "Returning Adventurer", -> {Hero.handle_returning_adventurer("Ah! Coming back for more, eh? Identify yourself!")}
        end
    end

    def main_menu
        puts "Welcome #{self.hero.name}!"
        answer = prompt.select("What do you want to do today?") do |menu|
            menu.choice "Enter Dungeon", -> {Dungeon.dungeons_by_hero(self.hero)}
            menu.choice "Check/Update Stats", -> {Hero.check_stats}
            menu.choice "Delete Adventurer", -> {Hero.delete_hero}
        end
    end

end
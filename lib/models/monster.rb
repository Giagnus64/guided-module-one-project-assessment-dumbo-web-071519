class Monster < ActiveRecord::Base 
    has_many :fights
    has_many :heros, through: :fights

    def self.get_monster_names
        response = RestClient.get("http://dnd5eapi.co/api/monsters/")
        parsed = JSON.parse(response)
        monster_names = parsed["results"].map{|monster_hash| monster_hash["name"]}
    end

end
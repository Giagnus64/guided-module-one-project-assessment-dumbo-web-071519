class Hero < ActiveRecord::Base 
    has_many :fights
    has_many :monsters, through: :fights
    has_many :dungeons, through: :fights

    def self.get_hero_names
        #calls the smash api to get character hashes
        response = RestClient.get("http://smashlounge.com/api/chars/all")
        #parsed the response into JSON
        parsed = JSON.parse(response)
        #pulls an array of character names out of JSON
        names = parsed.map{|character_hash| character_hash["name"]}
        names
    end
end
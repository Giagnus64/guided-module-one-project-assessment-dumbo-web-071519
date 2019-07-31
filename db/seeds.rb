# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Monster.get_monster_names

# delete all entries in tables
Hero.destroy_all()
Monster.destroy_all()
Fight.destroy_all()
Dungeon.destroy_all()

#create hero seeds
bob = Hero.create({
    name:"Bob", 
    strength: rand(5..20),
    victory_chant: "Huzzah!", 
    attack_chant: "Have at you!", 
    defeat_chant: "Drat!", 
    email: "bob@bob.com", 
    times_defeated: 0})
laura = Hero.create({
    name:"Laura", 
    strength: rand(5..20), 
    victory_chant: "Take that!", 
    attack_chant: "Engarde!", 
    defeat_chant: "Oh darn!", 
    email: "laura@bob.com", 
    times_defeated: 0}    
)

#create monster seeds
zombie = Monster.create({
    name: "Zombie", 
    strength: rand(1..10), 
    victory_noise: "Yum, fresh brains!",
    attack_noise: "Braaaains",
    defeat_noise: "How can you kill what's already dead?"
})

# vampire = Monster.create({
#   name: "Vampire",
#   strength: rand(10),
#   victory_noise: "slurp slurp",
#   defeat_noise: "POOF!",
#   attack_noise: "blaaeeehhh!"
# })


dung1 = Dungeon.seed_dungeon("easy", bob)

dung2 = Dungeon.seed_dungeon("medium", laura)

dung3 = Dungeon.seed_dungeon("easy", laura)



Fight.create({
    hero_id: laura.id,
    monster_id: zombie.id,
    dungeon_id: dung3.id,
    happened: true,
    winner: "Laura"
})

                # Fight.create({
                #     hero: bob,
                #     monster: zombie,
                #     dungeon: cave,
                #     happened: false
                #     })
                
                # Fight.create({
                #     hero_id: laura.id,
                #     monster_id: zombie.id,
                #     dungeon_id: cave.id,
                #     happened: false
                # })
                
                # Fight.create({
                #     hero_id: bob.id,
                #     monster_id: vampire.id,
                #     dungeon_id: cave.id,
                #     happened: false
                # })
                
                # Fight.create({
                #     hero_id: laura.id,
                #     monster_id: vampire.id,
                #     dungeon_id: castle.id,
                #     happened: false
                # })

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_31_185346) do

  create_table "dungeons", force: :cascade do |t|
    t.string "level"
    t.string "description"
    t.string "name"
  end

  create_table "fights", force: :cascade do |t|
    t.integer "hero_id"
    t.integer "monster_id"
    t.integer "dungeon_id"
    t.string "winner"
    t.boolean "happened"
  end

  create_table "heros", force: :cascade do |t|
    t.string "name"
    t.integer "strength"
    t.string "victory_chant"
    t.string "defeat_chant"
    t.string "attack_chant"
    t.integer "times_defeated"
    t.integer "user_id"
  end

  create_table "monsters", force: :cascade do |t|
    t.string "name"
    t.integer "strength"
    t.string "attack_noise"
    t.string "defeat_noise"
    t.string "victory_noise"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
  end

end

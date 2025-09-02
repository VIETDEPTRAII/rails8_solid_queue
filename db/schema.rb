# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_12_014134) do
  create_table "addresses", force: :cascade do |t|
    t.string "country", null: false
    t.string "street", null: false
    t.string "city", null: false
    t.string "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "country"
    t.string "phone"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "customers" because of following StandardError
#   Unknown type 'uuid' for column 'uuid'


  create_table "my_clients", primary_key: "uuid", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "country"
    t.string "phone"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "my_clients", column: "uuid", primary_key: "uuid"
end

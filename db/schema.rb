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

ActiveRecord::Schema.define(version: 20180511021405) do

  create_table "artisanusers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "openid"
    t.string "password_digest"
    t.string "username"
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "valicode"
    t.datetime "valitime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "headurl"
    t.integer "status"
    t.string "idfront_file_name"
    t.string "idfront_content_type"
    t.integer "idfront_file_size"
    t.datetime "idfront_updated_at"
    t.string "idback_file_name"
    t.string "idback_content_type"
    t.integer "idback_file_size"
    t.datetime "idback_updated_at"
    t.string "login"
  end

  create_table "artisanusers_servicecaps", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "artisanuser_id", null: false
    t.bigint "servicecap_id", null: false
  end

  create_table "barbasedefs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartaskdetail_id"
    t.string "name"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id"
  end

  create_table "barbasedefs_bartaskdetails", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "barbasedef_id", null: false
    t.bigint "bartaskdetail_id", null: false
  end

  create_table "barincrementdefs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartaskdetail_id"
    t.string "name"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id"
  end

  create_table "barincrementdefs_bartaskdetails", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "barincrementdef_id", null: false
    t.bigint "bartaskdetail_id", null: false
  end

  create_table "bartaskdetails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartask_id"
    t.string "product"
    t.string "productdetail"
    t.string "productattch"
    t.integer "number"
    t.integer "floor"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "barincrementdef_id"
    t.integer "barbasedef_id"
    t.integer "lock_id"
    t.integer "product_id"
    t.string "brand"
  end

  create_table "bartasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.float "preprice", limit: 24
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "address"
    t.integer "status"
    t.datetime "installtime"
    t.string "ordernumber"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact"
    t.string "contactphone"
    t.text "summary"
    t.integer "paytype"
  end

  create_table "eulas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "tile"
    t.text "eula"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fingers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartask_id"
    t.string "model"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "improves", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartask_id"
    t.string "model"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "lock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartask_id"
    t.float "roomintop", limit: 24
    t.float "roomouttop", limit: 24
    t.float "roomwidth", limit: 24
    t.integer "isfloorheat"
    t.integer "idding"
    t.float "dingleft", limit: 24
    t.float "dingright", limit: 24
    t.float "dingtop", limit: 24
    t.integer "doorset"
    t.integer "openinout"
    t.integer "openleftright"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "artisanuser_id"
    t.integer "bartask_id"
    t.float "price", limit: 24
    t.text "summary"
    t.integer "isselect"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "openlockimgs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "openlock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "openlocks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartask_id"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "product"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "servicecaps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "servicecap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "testlogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartask_id"
    t.string "start"
    t.string "end"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "openid"
    t.string "login"
    t.string "password_degest"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "headurl"
    t.string "valicode"
    t.datetime "valitime"
  end

end

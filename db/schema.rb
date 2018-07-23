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

ActiveRecord::Schema.define(version: 20180721185632) do

  create_table "artisancancelreasons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.string "artisanuserqrcodeimg_file_name"
    t.string "artisanuserqrcodeimg_content_type"
    t.integer "artisanuserqrcodeimg_file_size"
    t.datetime "artisanuserqrcodeimg_updated_at"
    t.bigint "up_id"
    t.bigint "user_id"
  end

  create_table "artisanusers_servicecaps", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "artisanuser_id", null: false
    t.bigint "servicecap_id", null: false
  end

  create_table "artisanusers_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "artisanuser_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "bankcards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "bankcode_id"
    t.bigint "artisanuser_id"
    t.string "cardnumber"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artisanuser_id"], name: "index_bankcards_on_artisanuser_id"
    t.index ["bankcode_id"], name: "index_bankcards_on_bankcode_id"
  end

  create_table "bankcodes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "bankcode"
    t.string "bank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "bartaskproimages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bartaskproimage_file_name"
    t.string "bartaskproimage_content_type"
    t.integer "bartaskproimage_file_size"
    t.datetime "bartaskproimage_updated_at"
    t.bigint "bartaskpro_id"
    t.index ["bartaskpro_id"], name: "index_bartaskproimages_on_bartaskpro_id"
  end

  create_table "bartaskpros", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartask_id"
    t.integer "artisanuser_id"
    t.datetime "begintime"
    t.datetime "endtime"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "receivable"
    t.integer "needreceivable"
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

  create_table "cancelorders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "cancelparty"
    t.bigint "user_id"
    t.bigint "artisanuser_id"
    t.float "amount", limit: 24
    t.float "refunduseramount", limit: 24
    t.text "reason"
    t.text "opinions"
    t.integer "status"
    t.float "refundartisanuseramount", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ordernumber"
    t.index ["artisanuser_id"], name: "index_cancelorders_on_artisanuser_id"
    t.index ["user_id"], name: "index_cancelorders_on_user_id"
  end

  create_table "chinadistricts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "code"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "couponbats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "number"
    t.float "facevalue", limit: 24
    t.float "condition", limit: 24
    t.integer "expirytype"
    t.datetime "assignexpiry"
    t.integer "fixedexpiry"
    t.integer "coupontype"
    t.text "summary"
    t.integer "generate"
    t.string "numbegin"
    t.string "numend"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
  end

  create_table "coupons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "couponbat_id"
    t.bigint "user_id"
    t.bigint "artisanuser_id"
    t.integer "model"
    t.float "facevalue", limit: 24
    t.float "condition", limit: 24
    t.integer "expirytype"
    t.datetime "assignexpiry"
    t.integer "fixedexpiry"
    t.string "ordernumber"
    t.integer "alreadyused"
    t.string "name"
    t.string "couponnumber"
    t.text "summary"
    t.integer "status"
    t.integer "coupontype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.index ["couponbat_id"], name: "index_coupons_on_couponbat_id"
  end

  create_table "eulas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "tile"
    t.text "eula"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fingermodeldefs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fingers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartask_id"
    t.string "model"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "fingermodeldef_id"
    t.index ["fingermodeldef_id"], name: "index_fingers_on_fingermodeldef_id"
  end

  create_table "improves", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bartask_id"
    t.string "model"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incomes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "artisanuser_id"
    t.float "amount", limit: 24
    t.string "bartaskorder"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artisanuser_id"], name: "index_incomes_on_artisanuser_id"
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
    t.integer "status"
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

  create_table "usercancelreasons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "userpayorders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "artisanuser_id"
    t.integer "user_id"
    t.integer "bartask_id"
    t.float "price", limit: 24
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ordernumber"
    t.float "score", limit: 24
    t.float "skillscore", limit: 24
    t.float "conceptscore", limit: 24
    t.float "attitudescore", limit: 24
    t.text "summary"
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
    t.bigint "artisanuser_id"
    t.bigint "up_id"
    t.string "userqrcodeimg_file_name"
    t.string "userqrcodeimg_content_type"
    t.integer "userqrcodeimg_file_size"
    t.datetime "userqrcodeimg_updated_at"
    t.string "province"
    t.string "city"
    t.string "district"
  end

  create_table "widthdraws", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "artisanuser_id"
    t.float "amount", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bankname"
    t.string "cardnumber"
    t.string "bank"
    t.integer "withdrawto"
    t.integer "processstatus"
    t.string "tradeno"
    t.string "summary"
    t.index ["artisanuser_id"], name: "index_widthdraws_on_artisanuser_id"
  end

  create_table "withdrawpwds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "artisanuser_id"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artisanuser_id"], name: "index_withdrawpwds_on_artisanuser_id"
  end

  add_foreign_key "bankcards", "artisanusers"
  add_foreign_key "bankcards", "bankcodes"
  add_foreign_key "bartaskproimages", "bartaskpros"
  add_foreign_key "cancelorders", "artisanusers"
  add_foreign_key "cancelorders", "users"
  add_foreign_key "coupons", "couponbats"
  add_foreign_key "fingers", "fingermodeldefs"
  add_foreign_key "incomes", "artisanusers"
  add_foreign_key "widthdraws", "artisanusers"
  add_foreign_key "withdrawpwds", "artisanusers"
end

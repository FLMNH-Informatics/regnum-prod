class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
    t.string   "login",                     :limit => nil
    t.string   "email",                     :limit => nil
    t.date     "created_at",                                                  :null => false
    t.date     "updated_at"
    t.string   "remember_token",            :limit => nil
    t.date     "remember_token_expires_at"
    t.string   "crypted_password",          :limit => 40,                     :null => false
    t.string   "salt",                      :limit => 40
    t.string   "activation_code",           :limit => nil
    t.string   "address_line1",             :limit => nil
    t.string   "address_line2",             :limit => nil
    t.string   "city",                      :limit => nil
    t.string   "state",                     :limit => nil
    t.string   "country",                   :limit => nil
    t.string   "zipcode",                   :limit => 10
    t.boolean  "enabled",                                  :default => false
    t.string   "password",                  :limit => nil
    t.string   "initials",                  :limit => nil
    t.integer  "phone"
    t.integer  "fax"
    t.string   "institution",               :limit => 100
    t.datetime "activated_at"
    t.integer  "people_id"
  end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end

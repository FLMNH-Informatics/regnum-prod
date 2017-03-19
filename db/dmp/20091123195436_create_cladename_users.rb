class CreateCladenameUsers < ActiveRecord::Migration
  def self.up
    create_table :cladename_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :cladename_users
  end
end

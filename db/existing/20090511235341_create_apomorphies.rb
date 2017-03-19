class CreateApomorphies < ActiveRecord::Migration
  def self.up
    create_table :apomorphies do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :apomorphies
  end
end

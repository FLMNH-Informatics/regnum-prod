class CreateNames < ActiveRecord::Migration
  def self.up
    create_table :names do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :names
  end
end

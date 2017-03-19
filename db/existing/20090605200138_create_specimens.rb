class CreateSpecimens < ActiveRecord::Migration
  def self.up
    create_table :specimens do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :specimens
  end
end

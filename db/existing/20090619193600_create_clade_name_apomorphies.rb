class CreateCladeNameApomorphies < ActiveRecord::Migration
  def self.up
    create_table :clade_name_apomorphies do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :clade_name_apomorphies
  end
end

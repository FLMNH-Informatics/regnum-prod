class CreateCladeNameSpecimens < ActiveRecord::Migration
  def self.up
    create_table :clade_name_specimens do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :clade_name_specimens
  end
end

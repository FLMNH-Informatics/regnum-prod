class CreateCladeNamePhylRefs < ActiveRecord::Migration
  def self.up
    create_table :clade_name_phyl_refs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :clade_name_phyl_refs
  end
end

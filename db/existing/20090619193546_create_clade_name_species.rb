class CreateCladeNameSpecies < ActiveRecord::Migration
  def self.up
    create_table :clade_name_species do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :clade_name_species
  end
end

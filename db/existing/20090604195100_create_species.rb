class CreateSpecies < ActiveRecord::Migration
  def self.up
    create_table :species do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :species
  end
end

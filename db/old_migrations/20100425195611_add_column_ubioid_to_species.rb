class AddColumnUbioidToSpecies < ActiveRecord::Migration
  def self.up
    add_column :species, :ubio_id, :integer
  end

  def self.down
  end
end

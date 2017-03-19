class AddDateAddedToClade < ActiveRecord::Migration
  def self.up
    add_column :cladenames, :approved_on, :datetime
  end

  def self.down
    remove_column :cladenames, :approved_on
  end
end

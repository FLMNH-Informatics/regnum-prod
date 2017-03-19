class AddEstablishedToCladeTable < ActiveRecord::Migration
  def self.up
    add_column :cladenames, :established, :boolean
  end

  def self.down
  end
end

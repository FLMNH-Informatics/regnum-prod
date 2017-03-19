class AddPeopleIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :people_id, :integer
  end

  def self.down
    remove_column :users, :people_id
  end
end



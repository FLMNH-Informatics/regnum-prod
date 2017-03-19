class AddStatusChangeTable < ActiveRecord::Migration
  def self.up
    create_table :status_change do |s|
      s.integer :id
      s.integer :submission_id
      s.integer :status_id
      s.datetime :changed_at
      s.string  :comments
    end
  end

  def self.down
  end
end

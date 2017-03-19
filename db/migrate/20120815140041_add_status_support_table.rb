class AddStatusSupportTable < ActiveRecord::Migration
  def self.up

    create_table :status do |t|
      t.integer :id
      t.integer :status_id
      t.string :status
    end

    execute %{
        INSERT INTO status (status_id, status) VALUES (1, 'unsubmitted'),(2, 'submitted'),(3, 'returned'),(4, 'approved'),(5, 'rejected')
    }
  end

  def self.down
  end
end

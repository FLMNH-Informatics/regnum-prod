class CreateGenericNames < ActiveRecord::Migration
  def self.up
    create_table :generic_names do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :generic_names
  end
end

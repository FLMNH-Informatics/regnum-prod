class AddUnsubmittedTable < ActiveRecord::Migration
  def self.up

    execute <<-SQL
       ALTER TABLE cladenames DROP FOREIGN KEY subb_fk_genericName_1
    SQL

    drop_table :submissions

    create_table :submissions do |t|
       t.integer :id
       t.text  :submission
       t.string :name
       t.integer :submitted_by
       t.timestamp :updated_at
       t.timestamp :submitted_at
       t.boolean :submitted
       t.boolean :returned
       t.boolean :approved
       t.integer :approved_by
    end
  end

  def self.down
    drop_table :submissions
    create_table :submissions do |t|
      t.integer :id
      t.date :created_at
      t.integer :status
      t.integer :user_id
      t.text :data
      t.boolean :submitted
      t.boolean :editable
    end
  end
end

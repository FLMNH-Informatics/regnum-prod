class CreateCladeTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :clade_types do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :old_value, null: true

      t.timestamps
    end

    add_index(:clade_types, :name, unique: true)
    add_index(:clade_types, :old_value, unique: true)
  end
end

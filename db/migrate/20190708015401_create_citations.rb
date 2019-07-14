class CreateCitations < ActiveRecord::Migration[5.2]
  def change
    create_table :citations, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string :title
      t.references :citation_type, foreign_key: true
      t.string :section_title
      t.text :authors
      t.text :editors
      t.text :series_editors
      t.string :publisher
      t.string :city
      t.string :edition
      t.string :book_section
      t.string :figure
      t.string :journal
      t.string :number
      t.string :pages
      t.string :isbn
      t.string :url
      t.string :doi
      t.string :volume
      t.string :year
      t.text :keywords

      t.references :created_by, foreign_key: { to_table: :users }, type: :integer

      t.timestamps
    end
  end
end

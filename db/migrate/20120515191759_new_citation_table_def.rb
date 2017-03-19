class NewCitationTableDef < ActiveRecord::Migration
  def self.up

    execute <<-SQL
      ALTER TABLE citations
      DROP FOREIGN KEY digitak_doc_fk_citations_1;
    SQL

    execute <<-SQL
      ALTER TABLE citations
      DROP FOREIGN KEY publication_fk_citations_1;
    SQL

    execute <<-SQL
      ALTER TABLE citations
      DROP FOREIGN KEY publisher_fk_citations_1;
    SQL

    execute <<-SQL
      ALTER TABLE citations
      DROP FOREIGN KEY user_fk_citations_1;
    SQL

    remove_column :citation, :digital_doc_id
    remove_column :citation, :publication_id
    remove_column :citation, :publisher_id
    remove_column :citation, :citations_attribute_id
    remove_column :citation, :user_id

    add_column :citation, :authors, :string
    add_column :citation, :publication_name, :string
    add_column :citation, :created_by, :integer
    add_column :citation, :pages, :string

  end

  def self.down
  end
end

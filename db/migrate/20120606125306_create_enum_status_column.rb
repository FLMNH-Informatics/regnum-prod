class CreateEnumStatusColumn < ActiveRecord::Migration
  def self.up

     execute %{
       ALTER TABLE citations ADD COLUMN citation_for ENUM('phylogeny','definition','preexisting');
     }

     remove_column :citations, :type

     execute %{
       ALTER TABLE citations ADD COLUMN type ENUM('book','book_section','journal','other');
     }

     add_column :cladenames, :preexisting, :boolean

     add_column :cladenames, :preexisting_code, :string

     add_column :cladenames, :preexisting_author, :string

     execute %{
        ALTER TABLE cladenames DROP FOREIGN KEY preexist_fk_genericName_1;
     }

     remove_column :cladenames, :preexisting_name_id

  end

  def self.down
  end
end

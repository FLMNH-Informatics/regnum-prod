class CreateCitationTypeTable < ActiveRecord::Migration[5.2]
  def change
    if ActiveRecord::Base.connection.table_exists? 'citation_types'
      drop_table :citation_types
    end

    create_table :citation_types do |t|
      t.string :citation_type
    end

    %w(book book_section journal).each{|citation_type|  CitationType.create citation_type: citation_type }
  end
end

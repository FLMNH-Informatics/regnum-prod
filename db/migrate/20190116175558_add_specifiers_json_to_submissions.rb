class AddSpecifiersJsonToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :specifiers_json, :json
  end
end

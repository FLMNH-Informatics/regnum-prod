class RemoveSpecifierDescriptionFieldForApomorphySpecifiers < ActiveRecord::Migration
  def change
    Submission.all.each do |submission|
      submission.specifiers.each { |specifier| specifier.delete('specifier_description') }
      submission.save!
    end
  end
end

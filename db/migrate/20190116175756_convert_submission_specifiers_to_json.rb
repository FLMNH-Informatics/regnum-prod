class ConvertSubmissionSpecifiersToJson < ActiveRecord::Migration[5.0]

  class TempSubmission < ApplicationRecord
    self.table_name = 'submissions'
    serialize :specifiers
  end

  def change
    TempSubmission.all.each do |sub|
      sub.specifiers_json = sub.specifiers.to_json
      sub.save!
    end
  end
end

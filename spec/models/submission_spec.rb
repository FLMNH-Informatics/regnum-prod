require 'spec_helper'

describe Submission do
  describe "saves" do
    it "saves submission data when submitted by user" do
      sub = FactoryGirl.create(:submission)
      expect(sub.id).to be_a_number
    end
  end

end
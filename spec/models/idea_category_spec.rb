require 'spec_helper'

describe IdeaCategory do
  describe "Validations/Associations" do
    it { should have_many :ideas }
    it { should validate_presence_of :name }
    it { should validate_presence_of :badge }
  end

  describe "#to_param" do
    it "Should concatenate id and name params" do
      @category = Factory.create(:idea_category)
      @category.to_param.should == "#{@category.id}-#{@category.name.parameterize}"
    end

  end
end

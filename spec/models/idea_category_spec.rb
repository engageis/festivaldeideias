require 'spec_helper'

describe IdeaCategory do
  describe "Validations/Associations" do
    it { should have_many(:ideas), :class_name => "Ideas" }
    it { should validate_presence_of :name }

  end

  describe "#to_param" do
    it "Should concatenate id and name params" do
      @category = create(:idea_category)
      @category.to_param.should == "#{@category.id}-#{@category.name.parameterize}"
    end

  end
end

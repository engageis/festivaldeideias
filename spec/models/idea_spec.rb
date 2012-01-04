require 'spec_helper'

describe Idea do
  describe "Validations/Associations" do

    it { should validate_presence_of :title }
    it { should validate_presence_of :headline }
    it { should validate_presence_of :category }

    describe "#user" do
      it { should belong_to :user }
    end

    describe "#parent" do
      it { should belong_to :parent }
    end

    describe "#category" do
      it { should belong_to :category }
    end

    describe "#to_param" do
      it "Should concatenate id and title" do
        @idea = Factory.create(:idea)
        @idea.to_param.should == "#{@idea.id}-#{@idea.title.parameterize}"
      end
    end
  end
end

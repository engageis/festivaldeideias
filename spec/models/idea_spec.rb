require 'spec_helper'

describe Idea do
  describe "Validations/Associations" do

    it { should validate_presence_of :title }
    it { should validate_presence_of :headline }

    describe "#user" do
      it { should belong_to :user }
    end
    describe "#parent" do
      it { should belong_to :parent }
    end

    describe "#category" do
      it { should belong_to :category }
    end
  end
end

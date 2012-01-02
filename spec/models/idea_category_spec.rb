require 'spec_helper'

describe IdeaCategory do
  describe "Validations/Associations" do
    it { should have_many :ideas }
    it { should validate_presence_of :name }
    it { should validate_presence_of :badge }
  end
end

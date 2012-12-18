require 'spec_helper'

describe Collaborator do

  describe "Validations/Associations" do
    it { should belong_to :idea }
    it { should belong_to :user }
    it { should validate_presence_of :idea_id }
    it { should validate_presence_of :user_id }
  end

end

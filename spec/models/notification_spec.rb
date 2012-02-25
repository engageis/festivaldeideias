require 'spec_helper'

describe Notification do
  describe "Notifications & Associations" do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :message }
  end
end

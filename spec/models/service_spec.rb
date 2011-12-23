require 'spec_helper'

describe Service do
  it { should validate_presence_of :uid }
  it { should validate_presence_of :uname }
  it { should validate_presence_of :uemail }
  it { should validate_presence_of :provider }


  describe "#user" do
    it { should belong_to :user }
  end
end

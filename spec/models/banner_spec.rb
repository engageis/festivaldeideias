require 'spec_helper'

describe Banner do

  describe "Validations/Associations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :link_text }
    it { should validate_presence_of :link_url }
    it { should validate_presence_of :image_url }
  end

  describe "#latest" do
    
    it "should return nil if empty" do
      Banner.latest.should be_nil
    end
    
    it "should return the latest visible video" do
      Banner.make! visible: true, title: "0001"
      Banner.make! visible: true, title: "0002"
      Banner.make! visible: false, title: "0003"
      Banner.latest.title.should == "0002"
    end
    
  end

end

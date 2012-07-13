require 'spec_helper'

describe InstitutionalVideo do

  describe "Validations/Associations" do
    it { should validate_presence_of :video_url }
  end

  describe "#latest" do
    
    it "should return nil if empty" do
      InstitutionalVideo.latest.should be_nil
    end
    
    it "should return the latest visible video" do
      InstitutionalVideo.make! visible: true, video_url: "http://youtube.com/watch?v=0001"
      InstitutionalVideo.make! visible: true, video_url: "http://youtube.com/watch?v=0002"
      InstitutionalVideo.make! visible: false, video_url: "http://youtube.com/watch?v=0003"
      InstitutionalVideo.latest.youtube_id.should == "0002"
    end
    
  end
  
  describe ".video_url" do

    before do
      subject.video_url = url
    end
    
    %w(http://www.youtube.com/watch?v=MX2ArQiavHU&feature=player_embedded https://www.youtube.com/watch?v=MX2ArQiavHU&feature=player_embedded http://www.youtube.com/watch?v=MX2ArQiavHU http://youtube.com/watch?v=MX2ArQiavHU).each do |sample_url|
      context "with a valid video URL: #{sample_url}" do
        let(:url) { sample_url }
        its(:valid?) { should be_true }
      end
    end
    
    %w(http://www.youtube.com/watch?v=&feature=player_embedded http://www.youtube.com/watch?MX2ArQiavHU&feature=player_embedded http://www.vimeo.com/watch?v=MX2ArQiavHU&feature=player_embedded www.youtube.com/watch?v=MX2ArQiavHU&feature=player_embedded).each do |sample_url|
      context "with an invalid video URL: #{sample_url}" do
        let(:url) { sample_url }
        its(:valid?) { should be_false }
      end
    end
    
  end

  describe ".youtube_id" do
    subject { InstitutionalVideo.make! video_url: "http://youtube.com/watch?v=MX2ArQiavHU" }
    its(:youtube_id) { should == "MX2ArQiavHU" }
  end
  
  describe ".embed_url" do
    subject { InstitutionalVideo.make! video_url: "http://youtube.com/watch?v=MX2ArQiavHU" }
    its(:embed_url) { should == "http://www.youtube.com/embed/MX2ArQiavHU?wmode=transparent" }
  end
  
end

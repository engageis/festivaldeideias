# coding: utf-8

class InstitutionalVideo < ActiveRecord::Base
  attr_accessible :video_url, :visible
  
  validates_presence_of :video_url
  
  def self.regex
    /\Ahttps?:\/\/(www\.)?youtube.com\/watch\?v=([^&]+)&?.*\z/
  end
  validates_format_of :video_url, with: self.regex, message: "somente URLs do YouTube são aceitas."

  def self.latest
    @latest = where(visible: true).order("updated_at DESC").limit(1)
    @latest.first
  end
  
  def youtube_id
    return @youtube_id if @youtube_id
    return unless self.video_url
    if result = self.video_url.match(self.class.regex)
      @youtube_id = result[2]
    end
  end
  
  def embed_url
    "http://www.youtube.com/embed/#{self.youtube_id}?wmode=transparent"
  end
  
end

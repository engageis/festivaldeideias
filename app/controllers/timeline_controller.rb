class TimelineController < ApplicationController
  
  def index
    @audits = Audit.recent.all.delete_if { |audit| audit.text.nil? }
    @recent_maximum_size = 10
    @recent_liked_ideas = []
  end
  
end

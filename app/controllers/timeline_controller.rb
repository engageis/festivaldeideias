class TimelineController < ApplicationController
  
  def index
    @audits = Audit.recent.all.delete_if { |audit| audit.text.nil? }
    @maximum_ideas = 10
    @recent_liked_ideas = []
    @recent_commented_ideas = []
  end
  
end

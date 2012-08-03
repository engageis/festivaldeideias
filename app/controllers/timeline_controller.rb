class TimelineController < ApplicationController
  
  def index
    @audits = Audit.recent.all
    @maximum_ideas = 10
    @recent_liked_ideas = []
    @recent_commented_ideas = []
  end
  
end

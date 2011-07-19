require 'nokogiri'
require 'open-uri'

desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  rest_server = 'http://api.facebook.com/restserver.php?method=links.getStats&urls='

  Idea.all.each do |idea|
    idea_url = idea.site.full_url("/pt/ideas/#{idea.id}-#{idea.title.parameterize}")
    url = "#{rest_server}#{idea_url}"
    res = Nokogiri::XML(open(url))
    idea.likes = res.search('like_count').children[0].content.to_i
    idea.save
  end
  
  # if Time.now.hour % 4 == 0 # run every four hours
  #   puts "Updating feed..."
  #   NewsFeed.update
  #   puts "done."
  # end
  # 
  # if Time.now.hour == 0 # run at midnight
  #   User.send_reminders
  # end
end
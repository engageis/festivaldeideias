require 'nokogiri'
require 'open-uri'

desc "This task is called by the Heroku cron add-on"
task :cron => :environment do

  puts "Setting URL"
  rest_server = 'http://api.facebook.com/restserver.php?method=links.getStats&urls='

  puts "Including Routes URL helpers"
  include Rails.application.routes.url_helpers

  # Run task every hour
  puts "Starting to update likes count for each idea"
  Idea.all.each do |idea|
    begin
      puts "Updating likes count for idea ##{idea.id}"
      idea_url = idea.site.full_url(idea_path(idea))
      puts idea_url
      url = "#{rest_server}#{idea_url}"
      res = Nokogiri::XML(open(url))
      idea.likes = res.search('total_count').children[0].content.to_i
      idea.send(:update_without_callbacks)
    rescue
      puts "Error updating likes count for idea ##{idea.id}"
    end
  end
end

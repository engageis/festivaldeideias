require 'json'
require 'open-uri'

desc "This task is called by the Heroku cron add-on"

task :cron => :environment do
  include Rails.application.routes.url_helpers
  ideas = Idea.all
  facebook_query_url = 'https://api.facebook.com/method/fql.query?format=json&query=' 
  urls = ideas.map { |idea| "'#{idea_url(idea)}'" }.join(',')
  fql = "SELECT url, total_count FROM link_stat WHERE url in (#{urls})";
  hash = Hash[JSON.parse(open(facebook_query_url + URI.encode(fql)).read).map { |j| [j['url'], j['total_count']] }]

  ideas.each do |idea|
    url = idea_url(idea)
    idea.update_attribute(:likes, hash[url] || 0)
  end
end


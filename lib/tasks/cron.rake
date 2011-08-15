require 'nokogiri'
require 'open-uri'

desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  access_token = Configuration.find_by_name("facebook_access_token")
  return nil unless access_token
  include Rails.application.routes.url_helpers

  urls_string = Idea.all.collect{|i| CGI.escape (i.site.full_url+idea_path(i))}.join(',')
  request_url = "https://api.facebook.com/method/links.getStats?urls=#{urls_string}&access_token=#{CGI.escape access_token.value}&format=json"
  url_stats = JSON.parse RestClient.get(request_url)
  puts "Total ideas on database: #{Idea.all.count}"
  puts "Total link stats received from fb #{url_stats.size}"
  url_stats.each do |data|
    begin
      id = data["normalized_url"].scan(/.+\/ideas\/([0-9]+)\-.+/)[0][0].to_i
      idea = Idea.find id
      idea.likes = data["total_count"].to_i
      idea.save
    rescue Exception => e
      Rails.logger.error "Error updating likes count for idea ##{idea.id}: #{e.message}"
    end
  end
end

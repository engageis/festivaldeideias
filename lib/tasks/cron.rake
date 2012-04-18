require 'json'
require 'open-uri'

desc "This task is called by the Heroku cron add-on"

task :cron => :environment do
  include Rails.application.routes.url_helpers
  default_url_options[:host] = 'festivaldeideias.org.br'
  #host_name = "http://festivaldeideias.org.br"
  ideas = Idea.select(['id', 'title', 'likes', 'category_id']).includes(:category)
  facebook_query_url = 'https://api.facebook.com/method/fql.query?format=json&query=' 

  sep = '-' * 80
  ideas.each_slice(40) do |slice|
    puts sep
    urls = slice.map { |idea| "'#{category_idea_url(idea.category, idea)}'" }.join(',')
    fql = "SELECT url, total_count FROM link_stat WHERE url in (#{urls})";
    puts "fql: #{fql}"
    hash = Hash[JSON.parse(open(facebook_query_url + URI.encode(fql)).read).map { |j| [j['url'], j['total_count']] }]
    hash_size = hash.size
    puts "Tamanho do hash: #{hash_size}"
    next if hash_size == 0
    slice.each do |idea|
      url = idea_url(idea)
      likes = hash[url]
      idea.update_attribute(:likes, likes.to_i) if likes
      puts "#{url} : #{idea.likes}"
    end
  end

end


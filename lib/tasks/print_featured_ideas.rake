require 'csv'

desc "Print featured ideas"
task :print_featured_ideas => :environment do
  include Rails.application.routes.url_helpers

  csv_string = CSV.generate do |csv|
    Idea.featured.each do |idea|
      csv << [idea.title,idea.user.name,idea.site.full_url+idea_path(idea),(idea.parent ? 'n' : 's'),(idea.parent_need_to_merge? ? 's' : 'n')]
    end
  end
  puts csv_string
end
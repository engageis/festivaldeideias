# coding: utf-8
require 'csv'

desc "Print featured ideas"
task :print_featured_ideas => :environment do
  include Rails.application.routes.url_helpers

  csv_string = CSV.generate do |csv|
    csv << ["Categoria","Título","Autor","Página da ideia","Primária"]
    Idea.featured.each do |idea|
      csv << [idea.category.name,idea.title,idea.user.name,idea.site.full_url+idea_path(idea),(idea.parent ? 'n' : 's')]
    end
  end
  puts csv_string
end
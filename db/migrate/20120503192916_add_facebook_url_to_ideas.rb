class AddFacebookUrlToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :facebook_url, :string

    Idea.reset_column_information
    route_helper = Rails.application.routes.url_helpers.method(:category_idea_path)
    url = "http://festivaldeideias.org.br"

    Idea.all.each do |idea|
      idea_path = url + route_helper.call(idea.category, idea)
      puts "Atualizando facebook_url da ideia \"#{idea.title}\" com path \"#{idea_path}\""
      idea.facebook_url = idea_path
      idea.save
    end
  end
end

# coding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create!(:name => "Luiz Fonseca", :email => "runeroniek@gmail.com")
service = Service.create!(:user => user, :uid => "100000428222603", :provider => "facebook")

# Categories
c1 = IdeaCategory.create(:name => "Mobilidade Urbana", :description => "Sample description", :badge => "")
c2 = IdeaCategory.create(:name => "Catástrofes Naturais", :description => "Sample description", :badge => "")
c3 = IdeaCategory.create(:name => "Violência", :description => "Sample description", :badge => "")


# Ideas
=begin
Idea.create!([
  { :category => c1, :user => user, :title => "Carona solidária", :headline => "Ao sair de casa informa seu percurso no sistema, seus contados confiáveis recebem a informação e podem se cadastrar para pegar uma carona", :description => "test?" },
  { :category => c2, :user => user, :title => "Carona solidária", :headline => "Ao sair de casa informa seu percurso no sistema, seus contados confiáveis recebem a informação e podem se cadastrar para pegar uma carona", :description => "test?" },

  { :category => c3, :user => user, :title => "Carona solidária", :headline => "Ao sair de casa informa seu percurso no sistema, seus contados confiáveis recebem a informação e podem se cadastrar para pegar uma carona", :description => "test?" },

  { :category => c1, :user => user, :title => "Carona solidária", :headline => "Ao sair de casa informa seu percurso no sistema, seus contados confiáveis recebem a informação e podem se cadastrar para pegar uma carona", :description => "test?" },

])
=end
%W(miguxo@facebooksucks.com juquinha@amoorkut.com sem.idea@email.com).each do |email|
  NonFacebookUser.create(:email => email)
end

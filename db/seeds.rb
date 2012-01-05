# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
user = User.create!(:name => "Luiz Fonseca", :email => "runeroniek@gmail.com")
service = Service.create!(:user => user, :uid => "547955110" , :provider => "facebook")

# Categories
c1 = IdeaCategory.create(:name => "Mobilidade Urbana", :description => "Sample description")
c1.badge.store!(File.open(File.join(Rails.root, "/spec/fixtures/images/disasters.png")))
c1.save

c2 = IdeaCategory.create(:name => "Catástrofes Naturais", :description => "Sample description")
c2.badge.store!(File.open(File.join(Rails.root, "/spec/fixtures/images/disasters.png")))
c2.save

c3 = IdeaCategory.create(:name => "Violência", :description => "Sample description")
c3.badge.store! File.open(File.join(Rails.root, "/spec/fixtures/images/disasters.png"))
c3.save


# Ideas
Idea.create!([
  { :category => c1, :user => user, :title => "Carona solidária", :headline => "Ao sair de casa informa seu percurso no sistema, seus contados confiáveis recebem a informação e podem se cadastrar para pegar uma carona", :description => "test?" },
  { :category => c2, :user => user, :title => "Circuito de webcam entre vizinhos", :headline => "Just testing the idea :D", :description => "Test, test." },
  { :category => c3, :user => user, :title => "Circuito de webcam entre vizinhos", :headline => "Just testing", :description => "Test, test." },
  { :category => c1, :user => user, :title => "Circuito de webcam entre vizinhos", :headline => "Just testing something", :description => "Test, test." }
])


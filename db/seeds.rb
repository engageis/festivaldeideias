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

Idea.create!([
  {:user => user, :title => "Ideia de teste", :headline => "Just a test, don't worry", :description => "test?" },
  {:user => user, :title => "Educação e lazer", :headline => "Just testing the idea :D", :description => "Test, test." },
  {:user => user, :title => "Lazer?", :headline => "Just testing", :description => "Test, test." },
  {:user => user, :title => "Violência", :headline => "Just testing something", :description => "Test, test." }
])


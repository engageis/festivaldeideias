# coding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

site_template = Template.create! :name => "Ideia", :description => "Modelo simples para a colaboração na evolução de uma ideia."

site = Site.create! :name => "Festival de Ideias · Centro Ruth Cardoso", :host => "localhost", :port => "3000", :auth_gateway => true, :template => site_template

site.links.create :name => "Sobre o Festival de Ideias", :href => '#'
site.links.create :name => "Sobre os temas", :href => '#'
site.links.create :name => "Regulamento", :href => '#'
site.links.create :name => "Premiação", :href => '#'
site.links.create :name => "Blog", :href => '#'
site.links.create :name => "Vídeos", :href => '#'
site.links.create :name => "Contato", :href => '#'

# TODO create a badge for each category with carrier wave
badge_path = "#{Rails.root.to_s}/lib/fixtures/badge.gif"
category_1 = Category.create! :site => site, :name => "Mobilidade urbana", :badge => badge_path
category_2 = Category.create! :site => site, :name => "Segurança comunitária", :badge => badge_path
category_3 = Category.create! :site => site, :name => "Catástrofes naturais", :badge => badge_path

user = User.create! :site => site, :provider => 'fake', :uid => 'foo_bar', :name => "Foo Bar"
user_2 = User.create! :site => site, :provider => 'fake', :uid => 'bar_foo', :name => "Bar Foo"

idea_1 = Idea.create! :site => site, :user => user, :category => category_1, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :featured => true, :recommended => true
idea_2 = Idea.create! :site => site, :user => user_2, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :featured => true, :recommended => true
idea_3 = Idea.create! :site => site, :user => user, :category => category_3, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :featured => true, :recommended => true
idea_4 = Idea.create! :site => site, :user => user, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :featured => true, :recommended => true

Idea.create! :parent => idea_1, :site => site, :user => user_2, :category => category_1, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 10

Idea.create! :parent => idea_2, :site => site, :user => user, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 9

Idea.create! :parent => idea_3, :site => site, :user => user_2, :category => category_3, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 8

Idea.create! :parent => idea_4, :site => site, :user => user_2, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 7

Idea.create! :parent => idea_1, :site => site, :user => user_2, :category => category_1, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 6

Idea.create! :parent => idea_2, :site => site, :user => user, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 5

Idea.create! :parent => idea_3, :site => site, :user => user_2, :category => category_3, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 4

Idea.create! :parent => idea_4, :site => site, :user => user_2, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 3

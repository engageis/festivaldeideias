# coding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Configuration.create :name => "git_document_db_url", :value => "http://username:password@localhost:4567/documents"

site_template = Template.create! :name => "Ideia", :description => "Modelo simples para a colaboração na evolução de uma ideia."

site = Site.create! :name => "Festival de Ideias · Centro Ruth Cardoso", :host => "localhost", :port => "3000", :auth_gateway => true, :template => site_template, :twitter => "centrorcardoso", :image => File.open("#{Rails.root.to_s}/lib/fixtures/site_logo.png")

site.links.create :name => "Sobre o Festival", :href => '#', :header => true
site.links.create :name => "Sobre os temas", :href => '#', :header => true
site.links.create :name => "Regulamento", :href => '#', :header => true
site.links.create :name => "Premiação", :href => '#', :header => true
site.links.create :name => "Blog", :href => '#'
site.links.create :name => "Vídeos", :href => '#'
site.links.create :name => "Contato", :href => '#'

category_1 = Category.create! :site => site, :name => "Mobilidade urbana", :badge => File.open("#{Rails.root.to_s}/lib/fixtures/mobilidade.png")
category_2 = Category.create! :site => site, :name => "Violência", :badge => File.open("#{Rails.root.to_s}/lib/fixtures/violencia.png")
category_3 = Category.create! :site => site, :name => "Catástrofes naturais", :badge => File.open("#{Rails.root.to_s}/lib/fixtures/catastrofes.png")

user = User.create! :site => site, :provider => 'fake', :uid => 'foo_bar', :name => "Foo Bar"
user_2 = User.create! :site => site, :provider => 'fake', :uid => 'bar_foo', :name => "Bar Foo"

idea_1 = Idea.create! :site => site, :user => user, :category => category_1, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :featured => true, :recommended => true, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }
idea_2 = Idea.create! :site => site, :user => user_2, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :featured => true, :recommended => true, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }
idea_3 = Idea.create! :site => site, :user => user, :category => category_3, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :featured => true, :recommended => true, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }
idea_4 = Idea.create! :site => site, :user => user, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :featured => true, :recommended => true, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }

Idea.create! :parent => idea_1, :site => site, :user => user_2, :category => category_1, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 10, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }

Idea.create! :parent => idea_2, :site => site, :user => user, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 9, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }

Idea.create! :parent => idea_3, :site => site, :user => user_2, :category => category_3, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 8, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }

Idea.create! :parent => idea_4, :site => site, :user => user_2, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 7, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }

Idea.create! :parent => idea_1, :site => site, :user => user_2, :category => category_1, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 6, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }

Idea.create! :parent => idea_2, :site => site, :user => user, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 5, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }

Idea.create! :parent => idea_3, :site => site, :user => user_2, :category => category_3, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 4, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }

Idea.create! :parent => idea_4, :site => site, :user => user_2, :category => category_2, :template => site.template, :title => "Circuito de webcams entre vizinhos", :headline => "Criar um sistema de monitoramento dos espaços públicos através de webcams que cada morador pode instalar.", :likes => 3, :document => { :description => "Descrição da ideia", :have => "O que eu já tenho", :need => "O que eu preciso" }

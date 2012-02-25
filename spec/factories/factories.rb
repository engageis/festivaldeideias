# coding: utf-8

# Defining sequencies
Factory.sequence(:name)     { |n| "User #{n}"          }
Factory.sequence(:email)    { |n| "user#{n}@gmail.com" }
Factory.sequence(:uid)      { |n| "#{n}"               }
Factory.sequence(:title)    { |n| "Title#{n}"          }
Factory.sequence(:headline) { |n| "Headline#{n}"       }

# Defining user factory
Factory.define :user do |u|
  u.name(Factory.next(:name))
  u.email(Factory.next(:email))
end

Factory.define :user_with_service, :parent => :user do |user|
  user.after_create { |u| Factory(:service, :user => u) }
end

Factory.define :admin_user do |u|
  u.email("user@example.com")
  u.password("super_safe")
end


# Defining provider factory (facebook, google, twitter - for instance)
Factory.define :service do |s|
  s.association :user, :factory => :user
  s.uid(Factory.next(:uid))
  s.provider("facebook")
end

Factory.define :idea_category do |c|
  c.name Factory.next(:title)
  c.badge File.open("#{Rails.root.to_s}/spec/fixtures/images/disasters.png")
  c.description "Some description"
end

Factory.define :idea do |i|
  i.association :category, :factory => :idea_category
  i.association :user, :factory => :user
  i.title(Factory.next(:title))
  i.headline(Factory.next(:headline))
  i.description("Some description")
  i.featured true
end

Factory.define :non_facebook_user do |hater|
  hater.email Factory.next :email
end

Factory.define :page do |page|
  page.title(Factory.next(:title))
  page.body '<p>Texto genérico de um parágrafo&hellip;</p>'
end

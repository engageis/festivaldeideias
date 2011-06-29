Factory.sequence :name do |n|
  "Foo bar #{n}"
end
Factory.sequence :email do |n|
  "person#{n}@example.com"
end
Factory.sequence :uid do |n|
  "#{n}"
end
Factory.define :template do |f|
  f.name { Factory.next(:name) }
  f.description 'bar'
end
Factory.define :site do |f|
  f.name { Factory.next(:name) }
  f.host { Factory.next(:name) }
  f.association :template, :factory => :template
end
Factory.define :user do |f|
  f.provider "twitter"
  f.uid { Factory.next(:uid) }
  f.name "Foo bar"
  f.email { Factory.next(:email) }
  f.bio "This is Foo bar's biography."
  f.association :site, :factory => :site
end
Factory.define :category do |f|
  f.association :site, :factory => :site
  f.name { Factory.next(:name) }
  f.badge 'foo.gif'
end
Factory.define :oauth_provider do |f|
  f.name 'GitHub'
  f.strategy 'GitHub'
  f.path 'github'
  f.key 'test_key'
  f.secret 'test_secret'
end
Factory.define :configuration do |f|
  f.name 'Foo'
  f.value 'Bar'
end
Factory.define :idea do |f|
  f.association :site, :factory => :site
  f.association :user, :factory => :user
  f.association :category, :factory => :category
  f.association :template, :factory => :template
  f.title 'Foo'
  f.headline 'Bar'
end

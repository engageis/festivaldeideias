# Defining sequencies
Factory.sequence(:name)   { |n| "User #{n}" }
Factory.sequence(:email)  { |n| "user#{n}@gmail.com" }
Factory.sequence(:uid)    { |n| "#{n}" }
Factory.sequence(:title)  { |n| "Title#{n}" }
Factory.sequence(:headline) { |n| "Headline#{n}" }

# Defining user factory
Factory.define :user do |u|
  u.name(Factory.next(:name))
  u.email(Factory.next(:email))
end

# Defining provider factory (facebook, google, twitter - for instance)
Factory.define :service do |s|
  s.association :user, :factory => :user
  s.uid(Factory.next(:uid))
  s.provider("facebook")
end

Factory.define :idea do |i|
  i.association :user, :factory => :user
  i.title(Factory.next(:title))
  i.headline(Factory.next(:headline))
  i.description("Some description")
end

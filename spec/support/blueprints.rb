require 'machinist/active_record'


AdminUser.blueprint do
  email { "email#{sn}@email.com" }
  password { "password" }
end

Service.blueprint do
  uid { "#{sn}" }
  provider { "facebook" }
  user
end


User.blueprint do
  name { "name#{sn}" }
  email { "email#{sn}@email.com" }
  notifications_read_at { Time.now }
end

IdeaCategory.blueprint do
  name        { "Name #{sn}" }
  description { "Description #{sn}" }
  badge       { "test" }
end

Idea.blueprint do
  title       { "Title #{sn}" }
  headline    { "Headline #{sn}" }
  description { "Description #{sn}" }
  category { IdeaCategory.make! } 
  minimum_investment { "R$ 5.000,00" }
  user { Service.make!.user }
  parent_id { nil }
  accepted { nil }
end

Page.blueprint do 
  title     { "Title #{sn}"} 
  body      { "<p>body</p>" }
  position  { sn }
end

NonFacebookUser.blueprint do 
  email { "email#{sn}@email.com" }
end


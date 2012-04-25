require 'machinist/active_record'

User.blueprint do
  name { "name#{sn}" }
  email { "email#{sn}@email.com" }
end

Service.blueprint do
  uid { "#{sn}" }
  provider { "facebook" }
  user
end

IdeaCategory.blueprint do
  name { "Name #{sn}" }
  description { "Description #{sn}" }
  badge { "test" }
end

Idea.blueprint do
  title { "Title #{sn}" }
  headline { "Headline #{sn}" }
  description { "Description #{sn}" }
  category
  user 
end

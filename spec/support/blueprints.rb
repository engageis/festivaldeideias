require 'machinist/active_record'

images_path = Rails.root + 'spec/support/images'

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
  badge { File.open(File.join(images_path, "apps.png")) }
  pin { File.open(File.join(images_path, "pins/apps.png")) }
end

Idea.blueprint do
  title       { "Title #{sn}" }
  headline    { "Headline #{sn}" }
  description { "Description #{sn}" }
  category { IdeaCategory.make! } 
  minimum_investment { "R$ 5.000,00" }
  user { Service.make!.user }
  accepted { nil }
end

Page.blueprint do 
  title     { "Title #{sn}" }
  body      { "<p>body</p>" }
  position  { sn }
end

NonFacebookUser.blueprint do 
  email { "email#{sn}@email.com" }
end

InstitutionalVideo.blueprint do 
  video_url { "http://www.youtube.com/watch?v=MX2ArQiavHU&feature=player_embedded" }
  visible { true }
end

Banner.blueprint do 
  title { "Title" }
  description { "Description" }
  link_text { "Link text" }
  link_url { "http://festivaldeideias.org.br/co-criacao" }
  image_url { "http://festivaldeideias.org.br/assets/pensar-junto.png" }
  visible { true }
end

Audit.blueprint do
  user { User.make! }
  idea { Idea.make! }
end
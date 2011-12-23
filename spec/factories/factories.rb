# Defining sequencies
Factory.sequence(:name)   { |n| "User #{n}" }
Factory.sequence(:email)  { |n| "user#{n}@gmail.com" }
Factory.sequence(:uid)    { |n| "#{n}" }

# Defining user factory
Factory.define :user do |u|
  u.name(Factory.next(:name))
  u.email(Factory.next(:email))
end

# Defining provider factory (facebook, google, twitter - for instance)
Factory.define :service do |s|
  s.association :user, :factory => :user
  s.uid(Factory.next(:uid))
  s.uname(Factory.next(:name))
  s.uemail(Factory.next(:email))
  s.provider("Facebook")
end

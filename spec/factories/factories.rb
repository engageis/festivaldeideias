# coding: utf-8

# Defining sequencies

FactoryGirl.define do 

  sequence(:name)     { |n| "Name#{n}"          }
  sequence(:email)    { |n| "user#{n}@gmail.com" }
  sequence(:uid)      { |n| "#{n}"               }
  sequence(:title)    { |n| "Title#{n}"          }
  sequence(:headline) { |n| "Headline#{n}"       }


  factory :user do
    name 
    email
  end

  factory :user_with_service, :parent => :user do
    after_create { |u| FactoryGirl(:service, :user => u) }
  end

  factory :admin_user do
    email("user@example.com")
    password("super_safe")
  end

  factory :service do
    association :user, factory: :user 
    uid
    provider "facebook"
  end

  factory :idea_category do
    name
    badge File.open("#{Rails.root.to_s}/spec/fixtures/images/disasters.png")
    description "Some description"
  end

  factory :idea do
    association :category, factory: :idea_category
    association :user, factory: :user
    title
    headline
    description "Some description"
    featured true
  end

  factory :non_facebook_user do
    email
  end

  factory :page do
    title
    body '<p>Texto genérico de um parágrafo&hellip;</p>'
  end
end

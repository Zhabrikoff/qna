# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyString' }

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end

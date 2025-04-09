# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user
    body { 'MyCommentString' }

    trait :invalid do
      body { nil }
    end
  end
end

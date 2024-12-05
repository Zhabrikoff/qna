# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyQuestionString' }
    body { 'MyQuestionString' }
    user

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end

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

    trait :with_file do
      after(:build) do |question|
        question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb')
      end
    end

    trait :with_link do
      after(:create) do |question|
        create(:link, linkable: question)
      end
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :award do
    name { 'MyString' }
    question

    image { Rack::Test::UploadedFile.new('spec/auxiliary/award.png', 'image/png') }
  end
end

FactoryBot.define do
  factory :book_request, class: LibraryAssistant::BookRequest do
    title { Faker::Book.title }
    author { Faker::Book.author }
    image_url { Faker::Internet.url }
    average_rating { rand(3.0..5.0).round(2) }

    initialize_with { new(attributes) }
  end
end

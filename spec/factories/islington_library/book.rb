FactoryBot.define do
  factory :islington_library_book, class: LibraryAssistant::IslingtonLibrary::Book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    year { rand(1900..2018) }
    link { Faker::Internet.url }

    initialize_with { new(attributes) }
  end
end

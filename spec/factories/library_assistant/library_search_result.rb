FactoryBot.define do
  factory :library_search_result, class: LibraryAssistant::LibrarySearchResult do
    trait :without_book do
    end

    trait :with_book do
      initialize_with { new(build(:islington_library_book)) }
    end
  end
end

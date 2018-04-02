require "library_assistant/version"
require "library_assistant/goodreads"

module LibraryAssistant
  def self.grab_a_book
    book = nil
    book_requests = generate_book_requests

    while !book && book_requests.any?
      book_request = book_requests.first
      book_request.perform_library_search!
      book = book_request.library_search_result.book
      book_requests.delete(book_request)
    end

    book
  end

  def self.generate_and_filter_book_requests
    generate_book_requests.
      map(&:perform_library_search!).
      select(&:book_found?)
  end

  def self.generate_book_requests
    Goodreads.generate_book_requests
  end
end

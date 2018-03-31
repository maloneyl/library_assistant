require "library_assistant/version"
require "library_assistant/goodreads"

module LibraryAssistant
  def self.grab_a_book
    found = false

    result = generate_book_requests.each do |request|
      request.perform_library_search!

      if found = request.book_found?
        break request.library_search_result.book
      end
    end

    found ? result : nil
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

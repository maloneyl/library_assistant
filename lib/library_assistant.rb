require "library_assistant/version"
require "library_assistant/goodreads"
require "library_assistant/islington_library"

module LibraryAssistant
  def self.grab_a_book
    found = false

    result = Goodreads.generate_book_requests.each do |request|
      request.library_search_result = IslingtonLibrary.search(title: request.title, author: request.author)

      if found = request.book_found?
        break request.library_search_result.book
      end
    end

    found ? result : nil
  end
end

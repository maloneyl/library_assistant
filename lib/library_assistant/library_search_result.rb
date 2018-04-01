module LibraryAssistant
  class LibrarySearchResult
    def initialize(book = nil)
      @book = book
    end

    attr_reader :book

    def book?
      book.present?
    end
  end
end

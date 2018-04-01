module LibraryAssistant
  class BookRequest
    def initialize(title:, author:, image_url:, average_rating:)
      @title = title
      @author = author
      @image_url = image_url
      @average_rating = average_rating
      @library_search_result = nil
    end

    attr_reader :title, :author, :image_url, :average_rating
    attr_accessor :library_search_result

    def book_found?
      return false unless @library_search_result

      @library_search_result.book?
    end
  end
end

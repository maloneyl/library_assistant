require "goodreads"
require "dotenv/load"
require "library_assistant/book_request"

module LibraryAssistant
  class Goodreads
    class << self
      def get_books_from_shelf
        client.shelf(ENV["GOODREADS_USER_ID"], ENV["GOODREADS_SHELF_NAME"]).books
      end

      def generate_book_requests
        get_books_from_shelf.map { |data| BookRequest.new(extracted_book_data(data)) }
      end

      private

      def client
        @client ||= ::Goodreads.new(api_key: ENV["GOODREADS_API_KEY"])
      end

      def extracted_book_data(data)
        {
          title: data.book.title,
          author: data.book.authors.author.name,
          image_url: data.book.image_url,
          average_rating: data.book.average_rating
        }
      end
    end
  end
end

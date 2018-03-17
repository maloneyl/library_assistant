require "goodreads"
require "dotenv/load"
require "library_assistant/goodreads/book"

module LibraryAssistant
  class Goodreads
    class << self
      def get_books
        client.shelf(ENV["GOODREADS_USER_ID"], ENV["GOODREADS_SHELF_NAME"]).books.map do |book_data|
          Book.new(book_data)
        end
      end

      private

      def client
        @client ||= ::Goodreads.new(api_key: ENV["GOODREADS_API_KEY"])
      end
    end
  end
end

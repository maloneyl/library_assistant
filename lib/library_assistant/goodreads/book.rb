module LibraryAssistant
  class Goodreads
    class Book
      def initialize(data)
        @title = data.book.title
        @author = data.book.authors.author.name
      end

      attr_reader :title, :author
    end
  end
end

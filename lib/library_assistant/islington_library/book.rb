module LibraryAssistant
  class IslingtonLibrary
    class Book
      def initialize(title:, author:, year:, link:, isbn:)
        @title = title
        @author = author
        @year = year
        @link = link
        @isbn = isbn
      end

      attr_reader :title, :author, :year, :link, :isbn
    end
  end
end

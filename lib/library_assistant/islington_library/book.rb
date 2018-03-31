module LibraryAssistant
  class IslingtonLibrary
    class Book
      def initialize(title:, author:, year:, link:)
        @title = title
        @author = author
        @year = year
        @link = link
      end

      attr_reader :title, :author, :year, :link
    end
  end
end

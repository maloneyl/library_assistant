require "library_assistant/library_search_result"
require "library_assistant/islington_library/book"

module LibraryAssistant
  class IslingtonLibrary
    class QueryResultInterpreter
      def initialize(parsed_query_result_xml)
        @doc = parsed_query_result_xml

        filter_to_books_only
      end

      def result
        return LibrarySearchResult.new unless any?

        LibrarySearchResult.new(
          Book.new(
            title: value_for_newest_item("rss:title"),
            author: value_for_newest_item("dc:creator"),
            year: value_for_newest_item("dc:date"),
            link: value_for_newest_item("rss:link")
          )
        )
      end

      private

      def filter_to_books_only
        return unless any?

        @doc.xpath("//rss:item/dc:format").each do |node|
          unless node.text == "Book"
            node.parent.remove
          end
        end
      end

      def any?
        @doc.xpath("//rss:item").any?
      end

      def newest_item
        @item ||= @doc.xpath("//rss:item/dc:date").
          sort_by{ |el| el.text }.
          reverse.
          first.
          parent
      end

      def value_for_newest_item(xpath)
        newest_item.xpath(xpath).text
      end
    end
  end
end

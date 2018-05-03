require "library_assistant/library_search_result"
require "library_assistant/islington_library/book"
require "fuzzystringmatch"

module LibraryAssistant
  class IslingtonLibrary
    class QueryResultInterpreter
      KNOWN_BOOK_FORMATS = ["Book", "Hardback", "Paperback", "Large print"].freeze
      ACCEPTED_JARO_WINKLER_DISTANCE = 0.8

      def initialize(doc:, requested_title:)
        @doc = doc
        @requested_title = requested_title

        screen_out_unwanted_items
      end

      def result
        return LibrarySearchResult.new unless items.any?

        LibrarySearchResult.new(
          Book.new(
            title: value_for_newest_item("rss:title"),
            author: value_for_newest_item("dc:creator"),
            year: value_for_newest_item("dc:date"),
            link: value_for_newest_item("rss:link"),
            isbn: value_for_newest_item("bibo:isbn")
          )
        )
      end

      private

      def screen_out_unwanted_items
        return unless items.any?

        items.each do |element|
          unless format_matches?(element.xpath("dc:format").map(&:text))
            element.remove
            next
          end

          unless title_matches?(element.xpath("rss:title").text)
            element.remove
          end
        end
      end

      def items
        @doc.xpath("//rss:item")
      end

      def newest_item
        @item ||= @doc.xpath("//rss:item/dc:date").
          sort_by{ |el| el.text }.
          reverse.
          first.
          parent
      end

      def value_for_newest_item(xpath)
        newest_item.xpath(xpath).first.text
      end

      def format_matches?(item_formats)
        (KNOWN_BOOK_FORMATS & item_formats).any?
      end

      def title_matches?(item_title)
        jaro_winkler_distance(item_title) >= ACCEPTED_JARO_WINKLER_DISTANCE
      end

      def jaro_winkler_distance(item_title)
        fuzzy_string_match.getDistance(item_title.downcase, @requested_title.downcase)
      end

      def fuzzy_string_match
        @fuzzy_string_match ||= FuzzyStringMatch::JaroWinkler.create(:native)
      end
    end
  end
end

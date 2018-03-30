require "nokogiri"
require "addressable"
require "open-uri"
require "library_assistant/islington_library/query_result"

module LibraryAssistant
  class IslingtonLibrary
    BASE_SEARCH_URL = "https://capitadiscovery.co.uk/islington/items.rss"

    class << self
      def search(title:, author:)
        new(title, author).search
      end
    end

    def initialize(title, author)
      @title = title.split(": ").first
      @author = author
    end

    def search
      QueryResult.new(parsed_query_result_xml).book
    end

    private

    def parsed_query_result_xml
      Nokogiri::XML(open(search_url_with_query))
    end

    def search_url_with_query
      uri = Addressable::URI.parse(BASE_SEARCH_URL)
      uri.query_values = {query: "#{@title} #{@author} AND format:(book)"}
      uri.to_s
    end
  end
end

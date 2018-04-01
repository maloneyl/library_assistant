module LibraryAssistant
  class BookRequest
    def initialize(title:, author:, image_url:, average_rating:)
      @title = title
      @author = author
      @image_url = image_url
      @average_rating = average_rating
      @library_result = nil
    end

    attr_reader :title, :author, :image_url, :average_rating
    attr_accessor :library_result

    def found?
      @library_result.present?
    end
  end
end

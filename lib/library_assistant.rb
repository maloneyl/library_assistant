require "library_assistant/version"
require "library_assistant/goodreads"

module LibraryAssistant
  def self.grab_a_book
    resulting_book_requests = generate_and_process_book_requests(desired_book_count: 1)

    return nil if resulting_book_requests.empty?

    resulting_book_requests.first.library_search_result.book
  end

  def self.generate_and_process_book_requests(opts = {})
    processed_book_requests = do_work(opts[:desired_book_count])

    return processed_book_requests if opts[:include_all]

    processed_book_requests.select(&:book_found?)
  end

  private

  def self.do_work(desired_book_count=nil, found_book_count=0, goodreads_shelf_page=1, processed_book_requests=[])
    desired_book_count = nil if desired_book_count && desired_book_count < 1

    book_requests = generate_book_requests(page: goodreads_shelf_page)
    return processed_book_requests if book_requests.empty?

    book_requests.each do |book_request|
      processed_book_requests << book_request.perform_library_search!
      found_book_count += 1 if book_request.book_found?
      break if found_book_count == desired_book_count
    end

    if (desired_book_count.nil?) || (found_book_count == desired_book_count)
      return processed_book_requests
    end

    do_work(desired_book_count, found_book_count, goodreads_shelf_page+1, processed_book_requests)
  end

  def self.generate_book_requests(page: 1)
    Goodreads.generate_book_requests(page: page)
  end
end

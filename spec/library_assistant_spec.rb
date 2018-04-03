RSpec.describe LibraryAssistant do
  it "has a version number" do
    expect(LibraryAssistant::VERSION).not_to be nil
  end

  shared_context "3 books from Goodreads shelf; last 2 found in Islington Library" do
    before do
      allow(described_class).to receive(:generate_book_requests).
        and_return(book_requests)

      book_requests.each_with_index do |book_request, i|
        allow(book_request).to receive(:perform_library_search!).
          and_return(processed_book_requests[i])
      end
    end

    let(:book_requests) { build_list(:book_request, 3) }

    let(:library_search_results) do
      [
        build(:library_search_result),
        build(:library_search_result, :with_book),
        build(:library_search_result, :with_book)
      ]
    end

    let(:processed_book_requests) do
      book_requests.each_with_index do |book_request, i|
        book_request.library_search_result = library_search_results[i]
      end
    end
  end

  describe ".grab_a_book" do
    include_context "3 books from Goodreads shelf; last 2 found in Islington Library"

    it "returns the first book from the Goodreads shelf that is available from the library" do
      expect(described_class.grab_a_book).to eq(library_search_results[1].book)
    end

    context "when the library doesn't have any of those books" do
      let(:library_search_results) { build_list(:library_search_result, 3, :without_book) }

      it "returns nil" do
        expect(described_class.grab_a_book).to be_nil
      end
    end
  end

  describe ".generate_and_handle_book_requests" do
    include_context "3 books from Goodreads shelf; last 2 found in Islington Library"

    it "creates and handles book requests" do
      resulting_book_requests = described_class.generate_and_handle_book_requests

      expect(resulting_book_requests.length).to eq(3)
      resulting_book_requests.each do |request|
        expect(request.library_search_result).to be_present
      end
    end

    context "when called with filter=true" do
      it "returns only the ones with books found in the library" do
        resulting_book_requests = described_class.generate_and_handle_book_requests(filter: true)

        expect(resulting_book_requests.length).to eq(2)

        expect(resulting_book_requests.first.title).to eq(book_requests[1].title)
        expect(resulting_book_requests.first.library_search_result).to eq(library_search_results[1])

        expect(resulting_book_requests.last.title).to eq(book_requests[2].title)
        expect(resulting_book_requests.last.library_search_result).to eq(library_search_results[2])
      end
    end
  end
end

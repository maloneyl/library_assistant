RSpec.describe LibraryAssistant do
  it "has a version number" do
    expect(LibraryAssistant::VERSION).not_to be nil
  end

  shared_context "5 books from Goodreads shelf; 2nd and 4th found in Islington Library" do
    before do
      allow(described_class).to receive(:generate_book_requests).
        and_return(book_requests, [])

      book_requests.each_with_index do |book_request, i|
        allow(book_request).to receive(:perform_library_search!).
          and_return(processed_book_requests[i])
      end
    end

    let(:book_requests) { build_list(:book_request, 5) }

    let(:library_search_results) do
      [
        build(:library_search_result),
        build(:library_search_result, :with_book),
        build(:library_search_result),
        build(:library_search_result, :with_book),
        build(:library_search_result)
      ]
    end

    let(:processed_book_requests) do
      book_requests.each_with_index do |book_request, i|
        book_request.library_search_result = library_search_results[i]
      end
    end
  end

  describe ".grab_a_book" do
    include_context "5 books from Goodreads shelf; 2nd and 4th found in Islington Library"

    it "returns the first book from the Goodreads shelf that is available from the library" do
      expect(described_class.grab_a_book).to eq(library_search_results[1].book)
    end

    context "when the library doesn't have any of those books" do
      let(:library_search_results) { build_list(:library_search_result, 5, :without_book) }

      it "returns nil" do
        expect(described_class.grab_a_book).to be_nil
      end
    end
  end

  describe ".generate_and_process_book_requests" do
    include_context "5 books from Goodreads shelf; 2nd and 4th found in Islington Library"

    let(:opts) { {} }

    subject { described_class.generate_and_process_book_requests(opts) }

    it "creates and processes book requests, returning the ones with books found" do
      expect(subject.length).to eq(2)

      expect(subject.first.title).to eq(book_requests[1].title)
      expect(subject.first.library_search_result).to eq(library_search_results[1])

      expect(subject.last.title).to eq(book_requests[3].title)
      expect(subject.last.library_search_result).to eq(library_search_results[3])
    end

    context "when called with opts[:include_all]" do
      let(:opts) { {include_all: true} }

      it "returns all processed book requests" do
        expect(subject.length).to eq(book_requests.length)

        subject.each do |request|
          expect(request.library_search_result).to be_present
        end
      end
    end

    context "when called with opts[:desired_book_count]" do
      let(:opts) { {desired_book_count: 2} }

      let(:book_requests_from_first_page_of_shelf) { book_requests.first(2) }
      let(:book_requests_from_second_page_of_shelf) { book_requests.last(2) }

      it "goes beyond the the first page Goodreads shelf results if needed to reach that book count" do
        expect(described_class).to receive(:generate_book_requests).
          and_return(book_requests_from_first_page_of_shelf, book_requests_from_second_page_of_shelf)

        expect(subject.length).to eq(2)
      end

      context "when the desired book count cannot be met as we've run out of Goodreads books to try" do
        let(:opts) { {desired_book_count: 3} }

        it "returns however many that can be found" do
          expect(described_class).to receive(:generate_book_requests).
            and_return(book_requests_from_first_page_of_shelf, book_requests_from_second_page_of_shelf, [])

          expect(subject.length).to eq(2)
        end
      end

      context "when the desired book count is less than 1" do
        let(:opts) { {desired_book_count: -1} }

        it "behaves as if this option wasn't given" do
          expect(described_class).to receive(:generate_book_requests).
            and_return(book_requests_from_first_page_of_shelf)

          expect(subject.length).to eq(1)
        end
      end
    end
  end
end

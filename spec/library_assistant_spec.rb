RSpec.describe LibraryAssistant do
  it "has a version number" do
    expect(LibraryAssistant::VERSION).not_to be nil
  end

  describe ".grab_a_book" do
    let(:book_requests) { build_list(:book_request, 3) }

    let(:expected_book) do
      described_class::IslingtonLibrary::Book.new(
        title: book_requests[1].title, author: book_requests[1].author,
        year: Object.new, link: Object.new
      )
    end

    before do
      allow(described_class::Goodreads).to receive(:generate_book_requests).
        and_return(book_requests)
      allow(described_class::IslingtonLibrary).to receive(:search).
        with(title: book_requests[0].title, author: book_requests[0].author).
        and_return(described_class::LibrarySearchResult.new)
      allow(described_class::IslingtonLibrary).to receive(:search).
        with(title: book_requests[1].title, author: book_requests[1].author).
        and_return(described_class::LibrarySearchResult.new(expected_book))
    end

    it "returns the first book from the Goodreads shelf that is available from the library" do
      expect(described_class.grab_a_book).to eq(expected_book)
    end

    context "when the library doesn't have any of those books" do
      before do
        allow(described_class::IslingtonLibrary).to receive(:search).
          and_return(nil)
      end

      it "returns nil" do
        expect(described_class.grab_a_book).to be_nil
      end
    end
  end
end

RSpec.describe LibraryAssistant do
  it "has a version number" do
    expect(LibraryAssistant::VERSION).not_to be nil
  end

  describe ".grab_a_book" do
    include GoodreadsHelper

    let(:goodreads_books) do
      sample_data_of_books_fetched_from_goodreads_shelf.map do |book_data|
        described_class::Goodreads::Book.new(book_data)
      end.first(3)
    end

    let(:expected_book) do
      described_class::Book.new(
        title: goodreads_books[1].title, author: goodreads_books[1].author,
        year: Object.new, link: Object.new
      )
    end

    before do
      allow(described_class::Goodreads).to receive(:get_books).and_return(goodreads_books)
      allow(described_class::IslingtonLibrary).to receive(:search).
        with(title: goodreads_books[0].title, author: goodreads_books[0].author).and_return(nil)
      allow(described_class::IslingtonLibrary).to receive(:search).
        with(title: goodreads_books[1].title, author: goodreads_books[1].author).and_return(expected_book)
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
require_relative "../support/goodreads_helper"

RSpec.describe LibraryAssistant::Goodreads do
  include GoodreadsHelper

  describe ".generate_book_requests" do
    let(:goodreads_data) { sample_result_of_fetching_books_from_goodreads_shelf }

    before do
      allow(described_class).to receive(:get_books_from_shelf).and_return(goodreads_data)
    end

    it "creates a BookRequest for each book grabbed from the shelf" do
      expect(LibraryAssistant::BookRequest).to receive(:new).with(
        title: "A Brief History of Time",
        author: "Stephen Hawking",
        image_url: "https://images.gr-assets.com/books/1333578746m/3869.jpg",
        average_rating: "4.13"
      )

      expect(LibraryAssistant::BookRequest).to receive(:new).with(
        title: "Testosterone Rex: Unmaking the Myths of Our Gendered Minds",
        author: "Cordelia Fine",
        image_url: "https://s.gr-assets.com/assets/nophoto/book/111x148-bcc042a9c91a29c1d680899eff700a03.png",
        average_rating: "3.75"
      )

      expect(LibraryAssistant::BookRequest).to receive(:new).with(
        title: "Internal Time: Chronotypes, Social Jet Lag, and Why You're So Tired",
        author: "Till Roenneberg",
        image_url: "https://images.gr-assets.com/books/1334176383m/13598053.jpg",
        average_rating: "3.69"
      )

      described_class.generate_book_requests
    end
  end
end

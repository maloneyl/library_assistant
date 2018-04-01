RSpec.describe LibraryAssistant::BookRequest do
  describe "#book_found?" do
    let(:book_request) do
      described_class.new(
        title: Object.new, author: Object.new,
        image_url: Object.new, average_rating: Object.new
      )
    end

    before { book_request.library_search_result = library_search_result }

    subject { book_request.book_found? }

    context "when library_search_result is nil" do
      let(:library_search_result) { nil }

      it { is_expected.to be_falsey }
    end

    context "when library_search_result is present" do
      let(:library_search_result) { LibraryAssistant::LibrarySearchResult.new }

      context "when the result has a book" do
        before do
          allow(library_search_result).to receive(:book?).and_return(true)
        end

        it { is_expected.to be_truthy }
      end

      context "when the result does not have a book" do
        before do
          allow(library_search_result).to receive(:book?).and_return(false)
        end

        it { is_expected.to be_falsey }
      end
    end
  end
end

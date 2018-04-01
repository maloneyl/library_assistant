RSpec.describe LibraryAssistant::BookRequest do
  describe "#book_found?" do
    let(:book_request) { build(:book_request) }

    before { book_request.library_search_result = library_search_result }

    subject { book_request.book_found? }

    context "when library_search_result is nil" do
      let(:library_search_result) { nil }

      it { is_expected.to be_falsey }
    end

    context "when library_search_result is present" do
      context "when the result has a book" do
        let(:library_search_result) { build(:library_search_result, :with_book) }

        it { is_expected.to be_truthy }
      end

      context "when the result does not have a book" do
        let(:library_search_result) { build(:library_search_result) }

        it { is_expected.to be_falsey }
      end
    end
  end
end

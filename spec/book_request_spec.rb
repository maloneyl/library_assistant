RSpec.describe LibraryAssistant::BookRequest do
  describe "#perform_library_search!" do
    subject { build(:book_request) }

    let(:library_search_result) { build(:library_search_result) }

    before do
      allow(LibraryAssistant::IslingtonLibrary).to receive(:search).
        with(title: subject.title, author: subject.author).
        and_return(library_search_result)
    end

    it "does a library search, stores the result and returns the instance" do
      expect { subject.perform_library_search! }.
        to change{ subject.library_search_result }.
        from(nil).to(library_search_result)
    end
  end
end

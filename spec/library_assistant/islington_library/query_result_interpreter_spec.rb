RSpec.describe LibraryAssistant::IslingtonLibrary::QueryResultInterpreter do
  subject { described_class.new(parsed_query_result_xml) }

  let(:parsed_query_result_xml) do
    Nokogiri::XML(File.read(File.expand_path(query_result_file_path, File.dirname(__FILE__))))
  end

  describe "#initialize" do
    let(:query_result_file_path) { "../../fixtures/islington_library_query_results/three_items_incl_two_non_books.xml" }

    it "filters out non-book items" do
      expect(subject.instance_variable_get(:@doc).xpath("//rss:item").count).to eq(1)
      expect(subject.instance_variable_get(:@doc).xpath("//rss:item/dc:format").text).to eq("HardbackBook")
    end
  end

  describe "#result" do
    context "when there are book items" do
      let(:query_result_file_path) { "../../fixtures/islington_library_query_results/two_items.xml" }

      it "returns the newer book" do
        result = described_class.new(parsed_query_result_xml).result

        expect(result.book.year).to eq("2015")
        expect(result.book.link).to eq("http://capitadiscovery.co.uk/islington/items/872958")
        expect(result.book.isbn).to eq("1785031139")
        expect(result.book.title).to eq("The Martian")
        expect(result.book.author).to eq("Weir, Andy, author.")
      end
    end

    context "when there are no book items" do
      let(:query_result_file_path) { "../../fixtures/islington_library_query_results/zero_items.xml" }

      it "returns a result with no book" do
        result = described_class.new(parsed_query_result_xml).result

        expect(result.book).to be_nil
      end
    end
  end
end

require "nokogiri"
require_relative "../../../lib/library_assistant/islington_library/query_result"

RSpec.describe LibraryAssistant::IslingtonLibrary::QueryResult do
  subject { described_class.new(parsed_query_result_xml) }

  let(:parsed_query_result_xml) do
    Nokogiri::XML(File.read(File.expand_path(query_result_file_path, File.dirname(__FILE__))))
  end

  describe "#initialize" do
    let(:query_result_file_path) { "../../fixtures/islington_library_query_results/three_items_incl_two_non_books.xml" }

    it "filters out non-book items" do
      expect(subject.instance_variable_get(:@doc).xpath("//rss:item").count).to eq(1)
      expect(subject.instance_variable_get(:@doc).xpath("//rss:item/dc:format").text).to eq("Book")
    end
  end

  describe "#book" do
    context "when there are book items" do
      let(:query_result_file_path) { "../../fixtures/islington_library_query_results/two_items.xml" }

      it "returns the newer book" do
        book = described_class.new(parsed_query_result_xml).book

        expect(book.year).to eq("2015")
        expect(book.link).to eq("http://capitadiscovery.co.uk/islington/items/872958")
      end
    end

    context "when there are no book items" do
      let(:query_result_file_path) { "../../fixtures/islington_library_query_results/zero_items.xml" }

      it "returns nil" do
        book = described_class.new(parsed_query_result_xml).book

        expect(book).to be_nil
      end
    end
  end
end

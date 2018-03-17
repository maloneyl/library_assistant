require_relative "../../../lib/library_assistant/goodreads/book"
require_relative "../../support/goodreads_helper"

RSpec.describe LibraryAssistant::Goodreads::Book do
  describe "#initialize" do
    include GoodreadsHelper

    subject { described_class.new(sample_data_of_books_fetched_from_goodreads_shelf.first) }

    it "extracts the title and author from the Goodreads data given and sets them as instance variables" do
      expect(subject.instance_variable_get(:@title)).to eq("A Brief History of Time")
      expect(subject.instance_variable_get(:@author)).to eq("Stephen Hawking")
    end
  end
end

RSpec.describe LibraryAssistant::IslingtonLibrary do
  describe "#initialize" do
    subject { described_class.new(title, "Author") }

    context "when the title has a 'subtitle'" do
      let(:title) { "Testosterone Rex: Unmaking the Myths of Our Gendered Minds" }

      it "strips the 'subtitle' from the title" do
        expect(subject.instance_variable_get(:@title)).to eq("Testosterone Rex")
      end
    end

    context "when the title does not have a 'subtitle'" do
      let(:title) { "The Martian" }

      it "leaves the title as it is" do
        expect(subject.instance_variable_get(:@title)).to eq("The Martian")
      end
    end
  end
end

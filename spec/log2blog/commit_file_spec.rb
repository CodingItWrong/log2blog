require "spec_helper"

module Log2Blog
  describe CommitFile do

    describe ".initialize( name:, diff: )" do

      it "should be instantiable with all named params" do
        described_class.new( name: "myname", diff: "mydiff" )
      end

      it "should require name" do
        expect{ described_class.new( diff: "mydiff" ) }.to raise_error(ArgumentError)
      end

      it "should require diff" do
        expect{ described_class.new( name: "mydiff" ) }.to raise_error(ArgumentError)
      end

      it "should not be instantiable with no params" do
        expect{ described_class.new }.to raise_error(ArgumentError)
      end

      it "should not be instantiable with unnamed params" do
        expect{ described_class.new( "myname", "mydiff" ) }.to raise_error(ArgumentError)
      end

    end

    context "instance methods" do

      subject { described_class.new( name: "myname", diff: "mydiff" ) }

      context "readers" do

        it "should allow accessing the name" do
          expect(subject.name).to eq("myname")
        end

        it "should allow accessing the diff" do
          expect(subject.diff).to eq("mydiff")
        end

      end

      context "writers" do

        it "should not allow accessing the name" do
          expect { subject.name = "fail" }.to raise_error(NoMethodError)
        end

        it "should not allow accessing the diff" do
          expect { subject.diff = "fail" }.to raise_error(NoMethodError)
        end

      end

      context "==" do

        it "should be equal to another commit file with identical fields" do
          expect(subject == subject.clone).to be true
        end

        it "should not be equal to another commit file with different fields" do
          other = described_class.new( name: "other", diff: "other" )
          expect(subject == other).to be false
        end

        it "should not be equal to an object of another class" do
          other = "a string"
          expect(subject == other).to be false
        end

        it "should not be equal to nil" do
          other = nil
          expect(subject == other).to be false
        end

      end

    end

  end
end

require "spec_helper"

module Log2Blog
  describe Commit do

    let(:all_params) { { user: "user",
                         repo: "repo",
                         sha: "mysha",
                         message: message,
                         files: "myfiles" } }
    let(:message) { "mysubject\nmydescription\nmoredescription" }

    describe ".initialize( sha:, message:, files: )" do

      it "should be instantiable with all named params" do
        described_class.new( all_params )
      end

      it "should require sha" do
        params = all_params.tap { |p| p.delete(:sha) }
        expect{ described_class.new( params ) }.to raise_error(ArgumentError)
      end

      it "should require message" do
        params = all_params.tap { |p| p.delete(:message) }
        expect{ described_class.new( params ) }.to raise_error(ArgumentError)
      end

      it "should require files" do
        params = all_params.tap { |p| p.delete(:files) }
        expect{ described_class.new( params ) }.to raise_error(ArgumentError)
      end

      it "should not be instantiable with no params" do
        expect{ described_class.new }.to raise_error(ArgumentError)
      end

      it "should not be instantiable with unnamed params" do
        params = all_params.values
        expect{ described_class.new( params ) }.to raise_error(ArgumentError)
      end

    end

    context "instance" do

      subject { described_class.new( all_params ) }

      context "readers" do

        it "should allow reading the sha" do
          expect(subject.sha).to eq(all_params[:sha])
        end

        it "should allow reading the message" do
          expect(subject.message).to eq(all_params[:message])
        end

        it "should allow reading the files" do
          expect(subject.files).to eq(all_params[:files])
        end

        it "should render a github commit url" do
          expect(subject.url).to eq("https://github.com/user/repo/commit/mysha")
        end

        it "should provide access to the commit subject" do
          expect(subject.subject).to eq("mysubject")
        end

        it "should provide access to the commit description" do
          expect(subject.description).to eq("mydescription\nmoredescription")
        end

        context "when there is no commit description" do
          let(:message) { "mysubject" }
          specify { expect(subject.description).to eq("") }
        end
      end

      context "writers" do

        it "should not allow writing the sha" do
          expect { subject.sha = "fail" }.to raise_error(NoMethodError)
        end

        it "should not allow writing the message" do
          expect { subject.message = "fail" }.to raise_error(NoMethodError)
        end

        it "should not allow writing the files" do
          expect { subject.files = "fail" }.to raise_error(NoMethodError)
        end

      end

      context "==" do

        it "should be equal to another commit with identical fields" do
          expect(subject == subject.clone).to be true
        end

        it "should not be equal to another commit with different fields" do
          other = described_class.new( user: "other",
                                       repo: "other",
                                       sha: "other",
                                       message: "other",
                                       files: ["other"] )
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

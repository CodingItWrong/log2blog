require "spec_helper"

module Log2Blog
  describe Generator do
    describe "#generate_markdown" do
      let(:user) { "TestUser" }
      let(:repo) { "TestRepo" }
      let(:generator) { Log2Blog::Generator.new( github ) }
      let(:github) { instance_double("Github") }

      before(:each) do
        allow(github).to receive(:history).with( user, repo ).and_return(commits)
        @markdown = generator.generate_markdown( user, repo )
      end

      context "when there are no commits" do
        let(:commits) { [] }

        it "returns an empty string" do
          expect(@markdown).to eq ""
        end
      end

      context "when there is one commit with one file" do
        let(:commit) { FactoryGirl.build(:commit, files: FactoryGirl.build_list(:commit_file, 1)) }
        let(:commits) { [commit] }

        it "includes the message" do
          expect(@markdown).to include(commit.message)
        end
        it "includes the filename" do
          expect(@markdown).to include(commit.files[0].filename)
        end
        it "includes the patch" do
          expect(@markdown).to include(commit.files[0].patch)
        end
      end

      context "when there is one commit with two files" do
        let(:commit) { FactoryGirl.build(:commit, files: FactoryGirl.build_list(:commit_file, 2) ) }
        let(:commits) { [commit] }

        it "includes the filenames in order" do
          positions = commit.files.map { |f| @markdown.index f.filename }
          expect(sorted?(positions)).to be true
        end
      end

      context "when there are two commits" do
        let(:commits) { FactoryGirl.build_list( :commit, 2 ) }

        it "includes the commit messages in order" do
          positions = commits.map { |c| @markdown.index c.message }
          expect(sorted?(positions)).to be true
        end
      end
    end
  end
end

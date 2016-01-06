require "spec_helper"

module Log2Blog
  describe Generator do
    describe "#generate_markdown" do
      let(:user) { "TestUser" }
      let(:repo) { "TestRepo" }
      let(:generator) { Generator.new( github ) }
      let(:github) { instance_double(GithubClient, history: commits) }

      before(:each) do
        @markdown = generator.generate_markdown( user, repo )
      end

      context "when there are no commits" do
        let(:commits) { [] }

        it "returns an empty string" do
          expect(@markdown).to eq ""
        end
      end

      context "when there is one commit with one file" do
        let(:commits) { [commit] }
        let(:commit) { FactoryGirl.build(:commit, files: [file] ) }
        let(:file) { FactoryGirl.build(:commit_file) }

        it "includes the message" do
          expect(@markdown).to include(commit.message)
        end
        it "includes the filename" do
          expect(@markdown).to include(file.filename)
        end
        it "includes the patch" do
          expect(@markdown).to include(file.patch)
        end
      end

      context "when there is one commit with two files" do
        let(:commits) { [commit] }
        let(:commit) { FactoryGirl.build(:commit, files: files ) }
        let(:files) { FactoryGirl.build_list(:commit_file, 2) }

        it "includes the filenames in order" do
          positions = files.map { |f| @markdown.index f.filename }
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

require "spec_helper"

module Log2Blog
  describe Generator do
    describe "#generate_markdown" do
      let(:generator) { Generator.new( github ) }
      let(:github) { instance_double(GithubClient, history: commits) }

      subject { generator.generate_markdown( "TestUser", "TestRepo" ) }

      context "when there are no commits" do
        let(:commits) { [] }
        it { should be_empty }
      end

      context "when there is one commit with one file" do
        let(:commits) { [commit] }
        let(:commit) { FactoryGirl.build(:commit, files: [file] ) }
        let(:file) { FactoryGirl.build(:commit_file) }

        it { should include(commit.message) }
        it { should include(file.filename) }
        it { should include(file.patch) }
      end

      context "when there is one commit with two files" do
        let(:commits) { [commit] }
        let(:commit) { FactoryGirl.build(:commit, files: files ) }
        let(:files) { FactoryGirl.build_list(:commit_file, 2) }

        it "includes the filenames in order" do
          positions = files.map { |f| subject.index f.filename }
          expect(positions).to be_sorted
        end
      end

      context "when there are two commits" do
        let(:commits) { FactoryGirl.build_list( :commit, 2 ) }

        it "includes the commit messages in order" do
          positions = commits.map { |c| subject.index c.message }
          expect(positions).to be_sorted
        end
      end
    end
  end
end

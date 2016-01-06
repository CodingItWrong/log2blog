require "spec_helper"

module Log2Blog
  describe Generator do
    subject(:generator) { described_class.new( github ) }
    let(:github) { instance_double(GithubClient, history: commits) }

    describe "#generate_markdown( user, repo )" do

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
        it { should include(file.name) }
        it { should include(file.diff) }
      end

      context "when there is one commit with two files" do
        let(:commits) { [FactoryGirl.build(:commit, files: files )] }
        let(:files) { FactoryGirl.build_list(:commit_file, 2) }

        it { is_expected.to contain_in_order( files.map(&:name) ) }
      end

      context "when there are two commits" do
        let(:commits) { FactoryGirl.build_list( :commit, 2 ) }

        it { is_expected.to contain_in_order( commits.map(&:message) ) }
      end
    end
  end
end

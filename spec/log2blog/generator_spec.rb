require "spec_helper"

module Log2Blog
  describe Generator do
    subject(:generator) { described_class.new( github ) }
    let(:github) { instance_double(GithubClient, history: commits) }

    describe "#generate_markdown( user, repo, starting_commit )" do

      subject { generator.generate_markdown( "TestUser", "TestRepo", starting_commit_hash ) }
      let(:starting_commit_hash) { nil }

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

      context "when there is a starting commit" do
        let(:too_old_commit) { FactoryGirl.build(:commit) }
        let(:starting_commit) { FactoryGirl.build(:commit) }
        let(:newer_commit) { FactoryGirl.build(:commit) }
        let(:rendered_commits) { [starting_commit, newer_commit] }
        let(:commits) { [too_old_commit] + rendered_commits }

        let(:starting_commit_hash) { starting_commit.sha }

        it { is_expected.to_not include(too_old_commit.message) }
        it { is_expected.to contain_in_order( rendered_commits.map(&:message) ) }
      end
    end
  end
end

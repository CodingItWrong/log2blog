require "spec_helper"

module Log2Blog
  describe Renderer do
    let(:renderer) { described_class.new(exclude: filenames_to_exclude) }
    let(:filenames_to_exclude) { nil }

    describe "#render" do

      subject { renderer.render(commits) }

      context "when there are no commits" do
        let(:commits) { [] }

        it { should be_empty }
      end

      context "when there is one commit with one file" do
        let(:commits) { [commit] }
        let(:commit) { FactoryGirl.build(:commit, files: [file] ) }
        let(:file) { FactoryGirl.build(:commit_file, diff: "@@ -0,0 +1,1 @@\n+hello, diff") }

        it { should include(commit.subject) }
        it { should include(commit.description) }
        it { should include(file.name) }

        it "should include the diff body" do
          expect(subject).to include("+hello, diff")
        end

        it "should not include the diff header line" do
          expect(subject).to_not include("@@ -0,0 +1,1 @@")
        end
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

      context "when there is a file to exclude" do
        let(:filename_to_exclude) { "irrelevant_file" }

        let(:file_to_exclude) { FactoryGirl.build(:commit_file, name: filename_to_exclude) }
        let(:file_to_include) { FactoryGirl.build(:commit_file) }
        let(:commits) { [FactoryGirl.build(:commit, files: [file_to_exclude, file_to_include] )] }

        let(:filenames_to_exclude) { [filename_to_exclude] }

        it { is_expected.to_not include(file_to_exclude.name) }
        it { is_expected.to include(file_to_include.name) }
      end
      
      context "when there is a pattern to exclude" do
        let(:filename_to_exclude) { "directory/*" }

        let(:file_to_exclude) { FactoryGirl.build(:commit_file, name: "directory/file.txt" ) }
        let(:file_to_include) { FactoryGirl.build(:commit_file) }
        let(:commits) { [FactoryGirl.build(:commit, files: [file_to_exclude, file_to_include] )] }

        let(:filenames_to_exclude) { [filename_to_exclude] }

        it { is_expected.to_not include(file_to_exclude.name) }
        it { is_expected.to include(file_to_include.name) }
      end
    end
  end
end

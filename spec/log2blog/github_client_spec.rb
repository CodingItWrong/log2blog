require "spec_helper"
require "github_api"

module Log2Blog
  describe GithubClient do
    subject(:api) { described_class.new(commit_api) }
    let(:commit_api) { instance_double(Github::Client::Repos::Commits) }

    describe "#history" do
      subject { api.history( "TestUser", "TestRepo" ) }

      before(:each) do
        allow(commit_api).to receive(:all).and_return([
          { "sha" => "2", "commit" => { "message" => "Message 2" } },
          { "sha" => "1", "commit" => { "message" => "Message 1" } },
        ])
        allow(commit_api).to receive(:get).with(any_args, "1").and_return(
          instance_double(Github::ResponseWrapper, body: {
            "files" => [
              { "filename" => "file1.txt", "patch" => "patch1" },
              { "filename" => "file2.txt", "patch" => "patch2" },
            ],
          })
        )
        allow(commit_api).to receive(:get).with(any_args, "2").and_return(
          instance_double(Github::ResponseWrapper, body: {
            "files" => [
              { "filename" => "file3.txt", "patch" => "patch3" },
              { "filename" => "file4.txt", "patch" => "patch4" },
            ],
          })
        )
      end

      it "should return all commits" do
        expect(subject.length).to eq(2)
      end

      it "should return SHAs oldest-to-newest" do
        expect(subject.map(&:sha)).to eq(["1","2"])
      end

      it "should return messages" do
        expect(subject.map(&:message)).to eq(["Message 1", "Message 2"])
      end

      it "should return all files for each commit" do
        subject.each { |c| expect(c.files.length).to eq(2) }
      end

      it "should return file names in order" do
        expect(subject.map { |c| c.files.map(&:name) }).to eq([["file1.txt","file2.txt"], ["file3.txt", "file4.txt"]])
      end

      it "should return file diffs in order" do
        expect(subject.map { |c| c.files.map(&:diff) }).to eq([["patch1","patch2"], ["patch3", "patch4"]])
      end

    end
  end
end

require "spec_helper"
require "github_api"

module Log2Blog
  describe GithubClient do
    subject(:api) { described_class.new(commit_api) }
    let(:commit_api) { instance_double(Github::Client::Repos::Commits) }

    describe "#history" do
      let(:user) { "TestUser" }
      let(:repo) { "TestRepo" }

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

      subject { api.history( user, repo ) }

      it "should return SHAs oldest-to-newest" do
        expect(subject.map(&:sha)).to eq(["1","2"])
      end

    end
  end
end

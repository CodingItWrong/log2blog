require "spec_helper"
require "github_api"

module Log2Blog
  describe GithubClient do
    describe "#history" do
      let(:commit_api) { instance_double(Github::Client::Repos::Commits) }
      let(:api) { GithubClient.new(commit_api) }
      let(:user) { "TestUser" }
      let(:repo) { "TestRepo" }

      before(:each) do
        allow(commit_api).to receive(:all).and_return([
          { "sha" => "2", "commit" => { "message" => "Message 2" } },
          { "sha" => "1", "commit" => { "message" => "Message 1" } },
        ])
        allow(commit_api).to receive(:get).with(user, repo, "1").and_return(
          instance_double(Github::ResponseWrapper, body: {
            "files" => [
              { "filename" => "file1.txt", "patch" => "patch1" },
              { "filename" => "file2.txt", "patch" => "patch2" },
            ],
          })
        )
        allow(commit_api).to receive(:get).with(user, repo, "2").and_return(
          instance_double(Github::ResponseWrapper, body: {
            "files" => [
              { "filename" => "file3.txt", "patch" => "patch3" },
              { "filename" => "file4.txt", "patch" => "patch4" },
            ],
          })
        )
      end

      subject! { api.history( user, repo ) }

      it "should request the commit list from github" do
        expect(commit_api).to have_received(:all).with(user, repo)
      end

      it "should request commit details from github" do
        expect(commit_api).to have_received(:get).with(user, repo, "1")
        expect(commit_api).to have_received(:get).with(user, repo, "2")
      end

      it "should return equivalent Commit objects oldest-to-newest" do
        expect(subject).to eq([
          Commit.new( "1", "Message 1", [
            CommitFile.new( "file1.txt", "patch1" ),
            CommitFile.new( "file2.txt", "patch2" ),
          ]),
          Commit.new( "2", "Message 2", [
            CommitFile.new( "file3.txt", "patch3" ),
            CommitFile.new( "file4.txt", "patch4" ),
          ]),
        ])
      end

    end
  end
end

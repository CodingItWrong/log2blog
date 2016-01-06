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
          Commit.new( sha: "1", message: "Message 1", files: [
            CommitFile.new( name: "file1.txt", diff: "patch1" ),
            CommitFile.new( name: "file2.txt", diff: "patch2" ),
          ]),
          Commit.new( sha: "2", message: "Message 2", files: [
            CommitFile.new( name: "file3.txt", diff: "patch3" ),
            CommitFile.new( name: "file4.txt", diff: "patch4" ),
          ]),
        ])
      end

    end
  end
end

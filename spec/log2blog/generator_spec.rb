require "spec_helper"

module Log2Blog
  describe Generator do
    describe "#generate_markdown" do
      let(:user) { "TestUser" }
      let(:repo) { "TestRepo" }
      let(:generator) { Log2Blog::Generator.new( github ) }
      let(:github) { instance_double("Github") }

      before(:each) do
        expect(github).to receive(:all).with( user, repo ).and_return(commits)
      end

      context "when there are no commits" do
        let(:commits) { [] }

        it "returns an empty string" do
          markdown = generator.generate_markdown( user, repo )
          expect(markdown).to eq ""
        end
      end

      context "when there is one commit with one file" do
        let(:commits) {
          [
            {
              "sha" => "12345",
              "commit" => {
                "message" => "This is what this commit is"
              }
            }
          ]
        }

        let(:commit_detail) {
          {
            "files" => [
              {
                "filename" => "test.rb",
                "patch" => <<-EOT
- FOO
+ BAR
                EOT
              }
            ]
          }
        }
        let(:commit_detail_response) {
          double("response", body: commit_detail)
        }

        before(:each) do
          allow(github).to receive(:get).with(user, repo, commits[0]["sha"]).and_return(commit_detail_response)
        end

        it "includes the message" do
          markdown = generator.generate_markdown( user, repo )
          expect(markdown).to include(commits[0]["commit"]["message"])
        end
        it "includes the filename" do
          markdown = generator.generate_markdown( user, repo )
          expect(markdown).to include(commit_detail["files"][0]["filename"])
        end
        it "includes the patch" do
          markdown = generator.generate_markdown( user, repo )
          expect(markdown).to include(commit_detail["files"][0]["patch"])
        end
      end

      context "when there is one commit with two files" do
        let(:commits) {
          [
            {
              "sha" => "12345",
              "commit" => {
                "message" => "This is what this commit is"
              }
            }
          ]
        }

        let(:commit_detail) {
          {
            "files" => [
              {
                "filename" => "test1.rb",
                "patch" => "patch"
              },
              {
                "filename" => "test2.rb",
                "patch" => "patch"
              }
            ]
          }
        }
        let(:commit_detail_response) {
          double("response", body: commit_detail)
        }

        before(:each) do
          allow(github).to receive(:get).with(user, repo, commits[0]["sha"]).and_return(commit_detail_response)
        end

        it "includes the filenames in order" do
          markdown = generator.generate_markdown( user, repo )
          positions = commit_detail["files"].map { |f| markdown.index f["filename"] }
          expect(sorted?(positions)).to eq(true)
        end
      end
    end
  end
end

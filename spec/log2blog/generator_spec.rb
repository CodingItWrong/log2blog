require "spec_helper"

module Log2Blog
  describe Generator do
    describe "#generate_markdown" do
      let(:user) { "TestUser" }
      let(:repo) { "TestRepo" }
      let(:generator) { Log2Blog::Generator.new( github ) }
      let(:github) { instance_double("Github") }

      before(:each) do
        expect(github).to receive(:history).with( user, repo ).and_return(commits)
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
            Commit.new( "12345", "This is what this commit is", [
              CommitFile.new("test.rb", "fakepatch")
            ])
          ]
        }

        it "includes the message" do
          markdown = generator.generate_markdown( user, repo )
          expect(markdown).to include(commits[0].message)
        end
        it "includes the filename" do
          markdown = generator.generate_markdown( user, repo )
          expect(markdown).to include(commits[0].files[0].filename)
        end
        it "includes the patch" do
          markdown = generator.generate_markdown( user, repo )
          expect(markdown).to include(commits[0].files[0].patch)
        end
      end

      context "when there is one commit with two files" do
        let(:commits) {
          [
            Commit.new( "12345", "This is what this commit is", [
              CommitFile.new("test1.rb", "patch"),
              CommitFile.new("test2.rb", "patch")
            ])
          ]
        }

        it "includes the filenames in order" do
          markdown = generator.generate_markdown( user, repo )
          positions = commits[0].files.map { |f| markdown.index f.filename }
          expect(sorted?(positions)).to eq(true)
        end
      end

      context "when there are two commits" do
        let(:commits) {
          [
            Commit.new( "2", "This is the newest commit", [] ),
            Commit.new( "1", "This is the oldest commit", [] )
          ]
        }

        it "includes the commit messages in order" do
          markdown = generator.generate_markdown( user, repo )
          positions = commits.map { |c| markdown.index c.message }
          expect(sorted?(positions)).to eq(true)
        end
      end
    end
  end
end

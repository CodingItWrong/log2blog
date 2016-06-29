require "spec_helper"

module Log2Blog
  describe Generator do
    subject(:generator) { described_class.new(github, renderer) }
    let(:github) { instance_double(GithubClient, history: commits) }
    let(:renderer) { instance_double(Renderer) }

    describe "#generate_markdown( user, repo, starting_commit )" do

      subject(:generate!) { generator.generate_markdown( "TestUser", "TestRepo", starting_commit_hash ) }
      let(:starting_commit_hash) { nil }

      context "when there is no starting commit" do
        let(:commits) { FactoryGirl.build_list(:commit, 3) }
        let(:starting_commit_hash) { nil }

        it "renders all commits" do
          expect(renderer).to receive(:render).with(commits)
          generate!
        end
      end

      context "when there is a starting commit" do
        let(:too_old_commit) { FactoryGirl.build(:commit) }
        let(:starting_commit) { FactoryGirl.build(:commit) }
        let(:newer_commit) { FactoryGirl.build(:commit) }
        let(:rendered_commits) { [starting_commit, newer_commit] }
        let(:commits) { [too_old_commit] + rendered_commits }

        let(:starting_commit_hash) { starting_commit.sha }

        it "renders the starting commit and later" do
          expect(renderer).to receive(:render).with(rendered_commits)
          generate!
        end
      end
    end
  end
end

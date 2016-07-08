module Log2Blog
  class Generator

    def initialize(commits_api: Github_api.new.repos.commits, renderer: Renderer.new)
      @commits_api = commits_api
      @renderer = renderer
    end

    def generate_markdown(user:, repo:, starting_commit: nil)
      renderer.render(commits_to_include(user, repo, starting_commit))
    end

    private

    attr_reader :commits_api, :renderer

    def commits_to_include(user, repo, starting_commit)
      commits = all_commits(user, repo)
      unless starting_commit.nil?
        commits = elements_after_match(commits) do |commit|
          commit.sha.start_with?(starting_commit)
        end
      end
      commits or raise "Commit not found"
    end

    def elements_after_match(array, &block)
      start_index = array.index &block
      array.slice(start_index..(array.length-1)) unless start_index.nil?
    end

    def all_commits(user, repo)
      commits_api.history(user, repo)
    end
  end
end

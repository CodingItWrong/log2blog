module Log2Blog
  class Renderer

    def initialize(commits_api = Github_api.new.repos.commits)
      @commits_api = commits_api
    end

    def render(commits)
      commits.map{ |commit| render_commit(commit) }.join("\n")
    end

    private

    attr_reader :commits_api

    def commits_to_include(user, repo, starting_commit)
      commits = all_commits(user, repo)
      unless starting_commit.nil?
        commits = elements_after_match(commits) do |commit|
          commit.sha.start_with?(starting_commit)
        end
      end
      commits
    end

    def elements_after_match(array, &block)
      start_index = array.index &block
      array.slice(start_index..(array.length-1))
    end

    def all_commits(user, repo)
      commits_api.history(user, repo)
    end

    def render_commit(commit)
      "\#\# #{commit.message}\n\n" + render_files( commit.files )
    end

    def render_files(files)
      files.map { |file| render_file(file) }.join("\n\n")
    end

    def render_file(file)
      <<-EOT
\#\#\# #{file.name}

```diff
#{file.diff}
```
      EOT
    end
  end
end

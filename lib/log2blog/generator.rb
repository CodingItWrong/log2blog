module Log2Blog
  class Generator

    def initialize( commits_api = Github_api.new.repos.commits )
      @commits_api = commits_api
    end

    def generate_markdown( user, repo )
      @commits_api.history( user, repo ).map{ |commit|
        render_commit(commit)
      }.join("\n")
    end

    private

    def render_commit(commit)
      "#{commit.message}\n\n" + render_files( commit.files )
    end

    def render_files(files)
      files.map { |file| render_file(file) }.join("\n\n")
    end

    def render_file(file)
      <<-EOT
#{file.name}

```diff
#{file.diff}
```
      EOT
    end
  end
end

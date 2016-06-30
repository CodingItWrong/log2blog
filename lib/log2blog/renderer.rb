module Log2Blog
  class Renderer

    def render(commits)
      commits.map(&method(:render_commit))
        .join("\n")
    end

    private

    def render_commit(commit)
      "\#\#\# #{commit.subject} [#{github_icon}](#{commit.url})\n\n" +
        render_files( commit.files ) +
        "#{commit.description}\n\n"
    end

    def render_files(files)
      files.map { |file| render_file(file) }.join("\n\n")
    end

    def render_file(file)
      <<-EOT
\#\#\#\# #{file.name}

```diff
#{file.diff}
```
      EOT
    end

    def github_icon
      '<span class="octicon octicon-mark-github"></span>'
    end
  end
end

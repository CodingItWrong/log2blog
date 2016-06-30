module Log2Blog
  class Renderer

    def render(commits)
      commits.map(&method(:render_commit))
        .join("\n")
    end

    private

    def render_commit(commit)
      "\#\#\# #{commit.message}\n\n" + render_files( commit.files )
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
  end
end

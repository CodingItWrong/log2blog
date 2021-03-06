module Log2Blog
  class Renderer

    def initialize(exclude:)
      @filenames_to_exclude = exclude
    end

    def render(commits)
      commits.map(&method(:render_commit))
        .join("\n")
    end

    private

    def filenames_to_exclude
      @filenames_to_exclude
    end

    def render_commit(commit)
      "\#\#\# #{commit.subject} [#{github_icon}](#{commit.url})\n\n" +
        render_files( commit.files ) +
        "#{commit.description}\n\n"
    end

    def render_files(files)
      exclude_by_filename(files).map { |file| render_file(file) }.join("\n\n")
    end

    def exclude_by_filename(files)
      if filenames_to_exclude.nil?
        files
      else
        files.reject { |file| Regexp.new(filenames_to_exclude) =~ file.name }
      end
    end

    def render_file(file)
      <<-EOT
\#\#\#\# #{file.name}

```diff
{% raw %}#{file.diff_body}{% endraw %}
```
      EOT
    end

    def github_icon
      '<span class="octicon octicon-mark-github"></span>'
    end
  end
end

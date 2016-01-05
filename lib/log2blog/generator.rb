module Log2Blog
  class Generator

    def initialize( commits_api = Github_api.new.repos.commits )
      @commits_api = commits_api
    end

    def generate_markdown( user, repo )
      @commits_api.all( user, repo ).map{ |item|
        detail = @commits_api.get( user, repo, item["sha"] )
        render_item(item, detail)
      }.join("\n")
    end

    private

    def render_item(item, detail)
      "#{item["commit"]["message"]}\n\n" + render_files( detail.body["files"] )
    end

    def render_files(files)
      files.map { |file| render_file(file) }.join("\n\n")
    end

    def render_file(file)
      <<-EOT
#{file["filename"]}

```diff
#{file["patch"]}
```
      EOT
    end
  end
end

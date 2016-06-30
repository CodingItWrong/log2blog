module Log2Blog

  class GithubClient

    def initialize(commit_api)
      @commit_api = commit_api
    end

    def history( user, repo )
      raw_commits( user, repo ).map do |summary|
        detail = raw_detail( user, repo, summary )
        build_commit( user, repo, summary, detail )
      end
    end

    private

    def raw_commits( user, repo )
      @commit_api.all( user, repo ).reverse_each
    end

    def raw_detail( user, repo, item )
      @commit_api.get( user, repo, item["sha"] )
    end

    def build_commit( user, repo, summary, detail )
      Commit.new(
        user: user,
        repo: repo,
        sha: summary["sha"],
        message: summary["commit"]["message"],
        files: build_files( detail.body["files"] )
      )
    end

    def build_files( raw_files )
      raw_files.map { |f| build_file(f) }
    end

    def build_file( raw_file )
      CommitFile.new( name: raw_file["filename"], diff: raw_file["patch"] )
    end

  end
end

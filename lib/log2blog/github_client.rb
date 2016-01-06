module Log2Blog

  class GithubClient

    def initialize(commit_api)
      @commit_api = commit_api
    end

    def history( user, repo )
      @commit_api.all( user, repo ).reverse.map do |item|
        detail = @commit_api.get( user, repo, item["sha"] )
        Commit.new( sha: item["sha"], message: item["commit"]["message"],
          files: detail.body["files"].map { |file|
            CommitFile.new( name: file["filename"], diff: file["patch"] )
          })
      end
    end

  end
end

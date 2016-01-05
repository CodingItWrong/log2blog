module Log2Blog

  Commit = Struct.new(:sha, :message, :files)
  CommitFile = Struct.new(:filename, :patch)

  class GithubClient

    def initialize(commit_api)
      @commit_api = commit_api
    end

    def history( user, repo )
      @commit_api.all( user, repo ).reverse.map do |item|
        detail = @commit_api.get( user, repo, item["sha"] )
        Commit.new( item["sha"], item["commit"]["message"],
          detail.body["files"].map { |file|
            CommitFile.new( file["filename"], file["patch"] )
          })
      end
    end

  end
end

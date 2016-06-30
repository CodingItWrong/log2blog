module Log2Blog

  class Commit

    attr_reader :user, :repo, :sha, :message, :files

    def initialize( user:, repo:, sha:, message:, files: )
      @user = user
      @repo = repo
      @sha = sha
      @message = message
      @files = files
    end

    def subject
      message_lines.first
    end

    def description
      message_lines[1..(message_lines.length)].join("\n")
    end

    def url
      "https://github.com/#{user}/#{repo}/commit/#{sha}"
    end

    def ==(other)
      return false if !other.instance_of?(Commit)
      self.sha == other.sha &&
        self.message == other.message &&
        self.files == other.files
    end

    private

    def message_lines
      message.split("\n")
    end

  end
end

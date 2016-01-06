module Log2Blog

  class Commit

    attr_reader :sha, :message, :files

    def initialize( sha:, message:, files: )
      @sha = sha
      @message = message
      @files = files
    end

    def ==(other)
      self.sha == other.sha &&
        self.message == other.message &&
        self.files == other.files
    end

  end
end

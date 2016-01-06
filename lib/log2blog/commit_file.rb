module Log2Blog
  class CommitFile

    attr_reader :filename, :patch

    def initialize( filename:, patch: )
      @filename = filename
      @patch = patch
    end

    def ==(other)
      self.filename == other.filename &&
        self.patch == other.patch
    end

  end
end

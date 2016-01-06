module Log2Blog
  class CommitFile

    attr_reader :name, :diff

    def initialize( name:, diff: )
      @name = name
      @diff = diff
    end

    def ==(other)
      self.name == other.name &&
        self.diff == other.diff
    end

  end
end

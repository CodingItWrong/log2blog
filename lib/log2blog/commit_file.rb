module Log2Blog
  class CommitFile

    attr_reader :name, :diff

    def initialize( name:, diff: )
      @name = name
      @diff = diff
    end

    def ==(other)
      return false if !other.instance_of?(CommitFile)
      self.name == other.name &&
        self.diff == other.diff
    end

  end
end

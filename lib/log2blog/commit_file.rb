module Log2Blog
  class CommitFile

    attr_reader :name, :diff

    def initialize( name:, diff: )
      @name = name
      @diff = diff
    end

    def diff_header
      if diff_lines.first.start_with?("@@")
        diff_lines.first
      end
    end

    def diff_body
      diff_lines.tap do |lines|
        lines.shift if lines.first.start_with?("@@")
      end.map do |line|
        if line.start_with?("@@")
          "..."
        else 
          line
        end
      end.join("\n")
    end

    def ==(other)
      return false if !other.instance_of?(CommitFile)
      self.name == other.name &&
        self.diff == other.diff
    end

    private

    def diff_lines
      @diff_lines ||= diff.split("\n")
    end

  end
end

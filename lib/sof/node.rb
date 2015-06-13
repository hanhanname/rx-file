# We transform objects into a tree of nodes

module Sof
  # abstract base class for nodes in the tree
  # may be referenced (should be a simple name or number)
  class Node
    include Util
    def initialize ref
      @referenced = ref
    end
    # must be able to output to a stream
    def out io ,level
      io.write "&#{@referenced} " if @referenced
    end
    def as_string(level)
      io = StringIO.new
      out(io,level)
      io.string
    end
    attr_reader :referenced
  end
end

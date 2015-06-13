# We transform objects into a tree of nodes

module Sof

  # What makes a node simple is that it has no further structure
  #
  class SimpleNode < Node
    def initialize data , ref = nil
      super(ref)
      @data = data
    end
    attr_reader :data
    def out io , level
      super(io,level)
      io.write(data)
    end
  end
  
end

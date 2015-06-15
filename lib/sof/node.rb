# We transform objects into a tree of nodes

module Sof

  # Before writing the objects are transformed into a tree of nodes.
  # as the Members (all objects) are a graph (not tree) this is achieved by referencing
  #
  # There are only two subclasses, SimpleNode and ObejctNode, for simple or not
  # The base class only holds the referenced flag
  # Also nodes must implement the out function

  class Node
    include Util
    # only has one attribute, the referenced flag
    # This could be anything, but we use a simple number counter which is handled in the Members
    #   class during construction of the occurrence hash
    def initialize ref
      #puts "node has ref #{self.class}:#{ref}" if ref
      @referenced = ref
    end
    attr_reader :referenced

    # must be able to output to a stream
    # This function must be called as super as it handles possible reference marker "& num"
    def out io ,level
      io.write "&#{@referenced} " if @referenced
    end

    # helper function to return the output as a string
    # ie creates stringio, calls out and returns the string
    def as_string(level)
      io = StringIO.new
      out(io,level)
      io.string
    end
  end
end

# We transform objects into a tree of nodes

module Sof

  # Before writing the objects are transformed into a tree of nodes.
  # as the Members (all objects) are a graph (not tree) this is achieved by referencing
  #
  # There are only two subclasses, SimpleNode and ObejctNode, for simple or not
  # The base class only holds the referenced flag

  # Node implements the out function which just checks wether a node is_simple?
  # and either calls short_out or long_out
  #
  # Notice that different instances of the same clas may be simple or not

  # So deriving classes must implement is_simple? and accordingly long/and or short_out

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

    # This ochastrates the output of derived classes to the stream
    # It writes any possible reference and sees if the noe is_simple? (see there)
    # and calls long / or short_out respectively
    def out io ,level
      io.write "&#{@referenced} " if @referenced
      if( is_simple? )
        short_out(io,level)
      else
        long_out(io,level)
      end
    end

    # Determine wether node is simple, meaning short, in the 30 char region
    # The point of hoisting this property into the public api is that
    #  other nodes may ask of their children and output accordingly
    def is_simple?
      raise "abstact function is_simple called for #{self}"
    end

    # helper function to return the output as a string
    # ie creates stringio, calls out and returns the string
    def as_string(level)
      io = StringIO.new
      out(io,level)
      io.string
    end

    private
    def short_out io , level
      raise "abstact function short_out called for #{self}"
    end

    def long_out io , level
      raise "abstact function long_out called for #{self}"
    end
  end
end

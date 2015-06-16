# If a class defines to_sof_node it tells the write that it will generate Nodes itself
# this delegates to array_to_sof_node
Array.class_eval do
  def to_sof_node(writer , level , ref )
    Sof.array_to_sof_node(self , writer , level , ref )
  end
end

module Sof
  # Creates a ArrayNode (see there) for the Array.
  # This mainly involves creating nodes for the children
  def self.array_to_sof_node(array , writer , level , ref )
    node = Sof::ArrayNode.new(ref)
    array.each do |object|
      node.add writer.to_sof_node( object , level + 1)
    end
    node
  end

  # A ArrayNode is a Node for an Array. See Node for when and how nodes are used in Sof.
  # A ArrayNode has a list of children that hold the value node representations for
  # the arrays values.
  #
  class ArrayNode < Node
    def initialize ref
      super(ref)
      @children = []
    end
    attr_reader  :children

    def add c
      @children << c
    end

    # The output of a Array can be a long or a short format
    # The short is used for 7 or less SimpleNodes
    def out io , level
      super
      short = true
      children.each do |c|
        short = false unless c.is_a?(SimpleNode)
      end
      if(short and children.length < 7 )
        short_out(io , level)
      else
        long_out(io , level)
      end
    end

    private
    # This defines the short output which is basically what you would write in ruby
    # ie [ value1 , value2 , ...]
    def short_out(io,level)
      io.write("[")
      @children.each_with_index do |child , i|
        child.out(io , level + 1 )
        io.write ", " unless (i+1) == children.length
      end
      io.write("]")
    end

    # Arrays start with the minus on each line "-"
    # and each line has the value
    def long_out io , level
      indent = " " * level
      @children.each_with_index do |child , i|
        io.write "\n#{indent}" unless i == 0
        io.write "- "
        child.out(io , level + 1)
      end
    end
  end
end

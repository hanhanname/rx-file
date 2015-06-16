Hash.class_eval do
  # If a class defines to_sof_node it tells the write that it will generate Nodes itself
  # this delegates to hash_to_sof_node
  def to_sof_node(writer , level , ref)
    Sof.hash_to_sof_node( self , writer , level , ref)
  end
end

module Sof
  # Creates a HashNode (see there) for the Hash.
  # This mainly involves creating nodes for key value pairs
  def self.hash_to_sof_node(hash,writer , level , ref)
    node = Sof::HashNode.new(ref)
    hash.each do |key , object|
      k = writer.to_sof_node( key ,level + 1)
      v = writer.to_sof_node( object ,level + 1)
      node.add(k , v)
    end
    node
  end

  # A HashNode is a Node for a Hash. See Node for when and how nodes are used in Sof.
  # A HashNode has a list of children that hold the key/value node representations for
  # the hashes keys and values.

  class HashNode < Node
    def initialize ref
      super(ref)
      @children = []
    end
    attr_reader  :children

    def add key , val
      @children << [key,val]
    end

    # The output of a Hash can be a long or a short format
    # The short is used for 7 or less SimpleNodes
    def out io , level
      super
      short = true
      children.each do |k,v|
        short = false unless k.is_a?(SimpleNode)
        short = false unless v.is_a?(SimpleNode)
      end
      if(short and children.length < 7 )
        short_out(io,level)
      else
        long_out(io , level)
      end
    end

    private
    # This defines the short output which is basically what you would write in ruby
    # ie { key1 => value1 , ... }
    def short_out(io,level)
      io.write("{")
      children.each_with_index do |child , i|
        key , val = child
        key.out(io , level + 1)
        io.write " => "
        val.out(io , level + 1)
        io.write ", " unless (i+1) == children.length
      end
      io.write("}")
    end

    # The long output is like an array of associations.
    # Arrays start with the minus on each line "-"
    # and each line has the association key => value, same as used for the {} syntax
    def long_out io , level
      indent = " " * level
      children.each_with_index do |child , i|
        key , val = child
        io.write "\n#{indent}" unless i == 0
        io.write "- "
        key.out(io , level + 1)
        io.write " => "
        val.out(io , level + 1)
      end
    end
  end
end

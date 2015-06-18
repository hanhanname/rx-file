module Sof
  # A HashNode is a Node for a Hash. See Node for when and how nodes are used in Sof.
  # A HashNode has a list of children that hold the key/value node representations for
  # the hashes keys and values.

  class HashNode < Node
    def initialize ref
      super(ref)
      @children = []
    end

    def add key , val
      @children << [key,val]
    end

    def is_simple?
      return false if(@children.length > 7 )
      @children.each do |k,v|
        return false unless k.is_simple?
        return false unless v.is_simple?
      end
      true
    end

    private
    # This defines the short output which is basically what you would write in ruby
    # ie { key1 => value1 , ... }
    # The short is used for 7 or less SimpleNodes
    def short_out(io,level)
      io.write("{")
      @children.each_with_index do |child , i|
        key , val = child
        key.out(io , level + 1)
        io.write " => "
        val.out(io , level + 1)
        io.write ", " unless (i+1) == @children.length
      end
      io.write("}")
    end

    # The long output is like an array of associations.
    # Arrays start with the minus on each line "-"
    # and each line has the association key => value, same as used for the {} syntax
    def long_out io , level
      indent = " " * level
      @children.each_with_index do |child , i|
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

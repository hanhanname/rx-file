

module RxFile

  # A ArrayNode is a Node for an Array. See Node for when and how nodes are used in RxFile.
  # A ArrayNode has a list of children that hold the value node representations for
  # the arrays values.
  #
  class ArrayNode < Node
    def initialize ref
      super(ref)
      @children = []
    end

    def add c
      @children << c
    end

    def is_simple?
      return false if(@children.length > 7 )
      short = true
      @children.each do |c|
        short = false unless c.is_simple?
      end
      short
    end

    # This defines the short output which is basically what you would write in ruby
    # ie [ value1 , value2 , ...]
    # The short is used for 7 or less SimpleNodes
    def short_out(io,level)
      io.write("[")
      @children.each_with_index do |child , i|
        child.out(io , level + 1 )
        io.write ", " unless (i+1) == @children.length
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

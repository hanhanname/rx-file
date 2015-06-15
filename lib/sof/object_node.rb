
module Sof

  # ObjectNode means node with structure
  # ie arrays and hashes get transformed into these too, as well as objects with attributes

  class ObjectNode < Node

    # init with a string, much like a simple node
    # structure is added after construction and kept in a children array
    def initialize data , ref
      super(ref)
      @data = data
      @children = []
    end
    attr_reader   :children ,  :data

    # children array hold key value pairs
    def add k , v
      @children << [k,v]
    end

    # write out at the given level
    # level determines the indentation (level * space)
    # write out the data and then the children (always key value on one line) 
    def out io , level = 0
      super
      io.write(@data)
      indent = " " * (level + 1)
      @children.each do |k,v|
        io.write "\n#{indent}"
        k.out(io , level + 1)
        io.write " "
        v.out(io , level + 1)
      end
    end
  end
end

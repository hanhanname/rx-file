
module Sof

  # ObjectNode means node with structure
  # ie arrays and hashes get transformed into these too

  class ObjectNode < Node
    def initialize data , ref
      super(ref)
      @data = data
      @children = []
    end
    attr_reader   :children ,  :data
    def add k , v
      @children << [k,v]
    end
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

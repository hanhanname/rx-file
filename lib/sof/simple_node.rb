module Sof

  # What makes a node simple is that it has no further structure
  #
  # This may mean number/string/symbol, but also tiny arrays or objects with
  # very little attributes. In other words simple/object is not the same distinction
  # as value/not value

  class SimpleNode < Node

    # data is a string that is written out in "out" function
    def initialize data , ref = nil
      super(ref)
      @data = data
    end
    attr_reader :data

    # just write the data given in construcor. simple. hence the name.
    def out io , level
      super(io,level)
      io.write(data)
    end
  end

end

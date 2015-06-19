module Sof

  # What makes a node simple is that it has no further structure
  #
  # This may mean number/string/symbol, but also tiny arrays or objects with
  # very little attributes. In other words simple/object is not the same distinction
  # as value/not value

  class SimpleNode < Node

    # data is a string that is written out in "out" function
    def initialize data
      super(nil) # simple nodes can not be referenced, always value
      @data = data
    end

    # A SimpleNode is always simple (aha).
    # accordingly there is no long_out
    def is_simple?
      true
    end

    private
    # just write the data given in construcor. simple. hence the name.
    def short_out io , level
      io.write(@data)
    end
  end

end

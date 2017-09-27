module RxFile

  # simple struct like class to wrap an object and hold additionally
  #  - the shallowest level at which it was seen
  #  - A possible reference
  #  - the fact if it has been written (for referenced objects)
  class Occurence
    def initialize object , level
      @object = object
      @level = level
      @referenced = nil
      @written = nil
    end
    def set_reference r
      raise "was set #{@referenced}" if @referenced
      @referenced = r
    end
    attr_reader   :object , :referenced
    attr_accessor :level , :written
  end

end

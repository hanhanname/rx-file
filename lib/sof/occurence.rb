module Sof

  class Occurence
    def initialize object , level
      @object = object
      @level = level
      @referenced = nil
      @written = nil
    end
    def set_reference r
      @referenced = r
    end
    attr_reader   :object , :referenced
    attr_accessor :level , :written
  end

end

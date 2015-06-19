
module Sof

  # ObjectNode means node with structure
  # ie arrays and hashes get transformed into these too, as well as objects with attributes

  class ObjectNode < Node

    # init with a string, much like a simple node
    # structure is added after construction and kept in a children array
    def initialize name , ref
      super(ref)
      @name = name
      @simple = {}
      @complex = {}
      @super = nil  # if derived from array or hash
    end

    # super is a hash or array, if the class of object derives from Hash/Array
    def add_super s
      @super = s
    end
    # attributes hold key value pairs
    def add k , v
      raise "Key should be symbol not #{k}" unless k.is_a? Symbol
      if( v.is_simple?)
        @simple[k] = v
      else
        @complex[k] = v
      end
    end

    # simple when no complex attributes and any
    # possible super is also simple
    def is_simple?
      if( @referenced.nil? and @complex.empty? and head.length < 30 )
        unless(@super and !@super.is_simple?)
          return true
        end
      end
      false
    end

    # write out at the given level
    # level determines the indentation (level * space)
    # write out the data and then the children (always key value on one line)
    def long_out io , level
      io.write(head)
      indent = " " * (level + 1)
      @complex.each do |k,v|
        io.write "\n#{indent}"
        io.write ":#{k}"
        io.write " "
        v.out(io , level + 1)
      end
      if(@super)
        io.write " "
        @super.long_out(io,level)
      end
    end

    def short_out io , level
      io.write head
      if(@super)
        if( @super.is_simple? )
          @super.short_out(io,level)
        else
          @super.long_out(io,level)
        end
      end
    end

    def head
      body = @simple.collect {|a,val| ":#{a} => #{val.as_string(1)}"}.join(", ")
      "#{@name}(#{body})"
    end
  end
end

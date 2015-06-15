module Sof

  # Members are members of the graph to be written
  # The class collects all reachable objects into a hash for further transformation

  class Members
    include Util

    # initialize with the "root" object
    # any object really that then becomes the root.
    # the result is easier to read if it really is a root
    # All reachable objects are collected into "objects" hash
    # The class keeps a counter for references encountered and creates unique
    # occurences for each object based on object_id (not == or ===)
    def initialize root
      @root = root
      @counter = 1
      @objects = {}
      add(root , 0)
    end
    attr_reader :objects , :root

    private
    # recursively add reachable objects from this object
    # this is called from the initialize and is private
    def add object , level
      # not storing simple (value) objects
      return if is_value?(object)

      # see if we we came accross this before
      if( occurence = @objects[object.object_id] )
        #puts "reset level #{level} at #{occurence.level}"
        if occurence.level > level
          #always store the most shallow level
          occurence.level = level
        end
        # and only one Occurence for each object, create a reference for the second occurence
        unless occurence.referenced
          #puts "referencing #{@counter} , at level #{level}/#{occurence.level} "
          occurence.set_reference(@counter)
          @counter = @counter + 1
        end
        return
      end

      # if first time see, create and store Occurence
      o = Occurence.new( object , level )
      @objects[object.object_id] = o

      # and recursively add attributes
      attributes = attributes_for(object)
      attributes.each do |a|
        val = get_value( object , a)
        add(val , level + 1)
      end
      # and array values
      if( object.is_a? Array )
        object.each do |a|
          add(a , level + 1)
        end
      end
      # and hash keys/values
      if( object.is_a? Hash )
        object.each do |a,b|
          add(a , level + 1)
          add(b , level + 1)
        end
      end
    end
  end
  # TODO, since this class only has one function, and one instance
  #  it could be merged as class functions to Occurence
end

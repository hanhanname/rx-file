module RxFile

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
      @references = []
      @objects = {}
      add_object( root , 0)
      collect_level(0 , [root])
    end
    attr_reader :objects , :root

    private
    # add object (as occurence) if it doesn't exist
    # return object or nil
    def add_object object , level
      # see if we we came accross this before
      if( occurence = @objects[object.object_id] )
        #puts "reset level #{level} at #{occurence.level}" if occurence.referenced #== 19
        if occurence.level > level
          #always store the most shallow level
          occurence.level = level
        end
        # and only one Occurence for each object, create a reference for the second occurence
        unless occurence.referenced
#          puts "referencing #{@counter} #{occurence.object.name}, at level #{level}/#{occurence.level} " if @counter == 23
#          puts "referencing #{@counter} #{occurence.object.name}, at level #{level}/#{occurence.level} " if @counter == 19
          if object.respond_to? :rxf_reference_name
            reference = object.rxf_reference_name
            reference = reference.to_s.gsub(/\s|\W/ , "") #remove space and stuff
            if( @references.include?(reference) or reference.empty?)
              reference = "#{reference}-#{@counter}"
              @counter = @counter + 1
            end
          else
            reference = @counter.to_s
            @counter = @counter + 1
          end
          occurence.set_reference(reference)
          @references << reference
        end
        return nil
      end
      # if first time see, create and store Occurence
      @objects[object.object_id] =  Occurence.new( object , level )
      return object
    end

    # recursively find reachable objects from this level of objects
    # this is called from the initialize and is private
    # we go through the tree in breadth first (which is a little more effort) to catch lowest
    # references.
    def collect_level level , objects
      next_level = Array.new
      #puts "collect level #{level} #{objects.length}"
      objects.each do |object|
        #puts "collect level #{level} #{object.object_id}"
        # not storing simple (value) objects
        next if is_value?(object)
        case object.class.name
        when "Array" , "Parfait::List"
          collect_array object , next_level
        when "Hash" , "Parfait::Dictionary"
          collect_hash object, next_level
        else
          # and recursively add attributes
          attributes = attributes_for(object)
          attributes.each do |a|
            val = get_value( object , a)
            next_level << val
          end
          #TODO get all superclsses here, but this covers 99% so . . moving on
          superclasses = [object.class.superclass.name]
          if superclasses.include?( "Array") or superclasses.include?( "Parfait::List")
            collect_array object, next_level
          end
          if superclasses.include?( "Hash") or superclasses.include?( "Parfait::Dictionary")
            collect_hash object, next_level
          end
        end
      end
      new_objects = next_level.collect { |o| add_object(o , level + 1) }
      new_objects.compact!
      # recurse , but break off if hit bottom
      collect_level( level + 1 , new_objects) unless new_objects.empty?
    end

    # and hash keys/values
    def collect_hash hash , next_level
      hash.each do |a,b|
        next_level << a
        next_level << b
      end
    end
    # and array values
    def collect_array array , next_level
      array.each do |a|
        next_level << a
      end
    end
  end
end

module Sof

  # this function writes the object (and all reachable objects) out as sof
  # and returns a string
  # For trees or graphs this works best by handing roots
  # Internally this is done in three steps:
  # - All reachable objects are collected, these are called Occurences and the Members class does
  #     the collecting. Members holds a hash of occurences
  # - A tree of nodes is created from the occurences. Different node classes for different classes
  # - The nodes are witten to a steam
  def self.write object
    writer = Writer.new(Members.new(object) )
    writer.write
  end

  # The writer does the coordinating work of the stages (see write function)
  class Writer
    include Util

    # Initialized with the Members (hash of occurences, see there)
    def initialize members
      @members = members
    end

    # main function, creates nodes from the occurences and writes the nodes to a string
    # returns the sof formatted string for all objects
    def write
      node = to_sof_node(@members.root , 0)
      io = StringIO.new
      node.out( io , 0 )
      io.string
    end

    # create a Node (subclass) for an object at a given level.
    # Level is mainly needed for the indenting
    # from the object we get the Occurence and decide wether a reference node is needed
    # simple objects (with more inner structure) become SimpleNodes
    # Any structured object becomes a ObjectNode
    # Hash and Array create their own nodes via  to_sof_node functions on the classes
    def to_sof_node(object , level)
      if is_value?(object)
        return SimpleNode.new(object.to_sof())
      end
      occurence = @members.objects[object.object_id]
      raise "no object #{object}" unless occurence
      #puts "#{level} ? #{occurence.level} : ref #{occurence.referenced}"
      if( occurence.referenced )
        #puts "ref #{occurence.referenced} level #{level} at #{occurence.level}"
        return SimpleNode.new("->#{occurence.referenced}") unless (level == occurence.level )
        if( occurence.written.nil? )
          occurence.written = true
        else
          return SimpleNode.new("->#{occurence.referenced}")
        end
      end

      ref = occurence.referenced
      case object.class.name
      when "Array" , "Parfait::List"
        # If a class defines to_sof_node it tells the write that it will generate Nodes itself
        # this delegates to array_to_sof_node
        array_to_sof_node(object , level , ref )
      when "Hash" , "Parfait::Dictionary"
        # and hash keys/values
        hash_to_sof_node( object , level , ref)
      else
        object_to_sof_node(object , level , ref)
      end

    end

    # create an object node from the object
    # simple nodes are returned for small objects
    #   small means only simple attributes and only 30 chars of them
    # object nodes are basically arrays (see there)
    #
    # objects may be derived from array/hash. In that case the ObjectNode gets a super
    #  (either ArrayNode or HashNode)
    def object_to_sof_node( object , level , ref)
      node = ObjectNode.new(object.class.name , ref)
      attributes_for(object).each() do |a|
        val = get_value(object , a)
        next if val.nil?
        node.add( a , to_sof_node( val , level + 1) )
      end
      #TODO get all superclsses here, but this covers 99% so . . moving on
      superclasses = [object.class.superclass.name]
      if superclasses.include?( "Array") or superclasses.include?( "Parfait::List")
        node.add_super( array_to_sof_node(object , level , ref ) )
      end
      if superclasses.include?( "Hash") or superclasses.include?( "Parfait::Dictionary")
        node.add_super( hash_to_sof_node(object , level , ref ) )
      end
      node
    end

    # Creates a ArrayNode (see there) for the Array.
    # This mainly involves creating nodes for the children
    def array_to_sof_node(array , level , ref )
      node = Sof::ArrayNode.new(ref)
      array.each do |object|
        node.add to_sof_node( object , level + 1)
      end
      node
    end

    # Creates a HashNode (see there) for the Hash.
    # This mainly involves creating nodes for key value pairs
    def hash_to_sof_node(hash , level , ref)
      node = Sof::HashNode.new(ref)
      hash.each do |key , object|
        k = to_sof_node( key ,level + 1)
        v = to_sof_node( object ,level + 1)
        node.add(k , v)
      end
      node
    end

  end
end

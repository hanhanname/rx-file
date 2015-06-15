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
    # Any structured object bocomes a ObjectNode
    # Hash and Array create their own nodes via  to_sof_node functions on the classes
    def to_sof_node(object , level)
      if is_value?(object)
        return SimpleNode.new(object.to_sof())
      end
      occurence = @members.objects[object.object_id]
      raise "no object #{object}" unless occurence
      #puts "#{level} ? #{occurence.level} : ref #{occurence.referenced}"
      if( occurence.referenced and (occurence.level <= level) )
        #puts "ref #{occurence.referenced} level #{level} at #{occurence.level}"
        if( occurence.written.nil? )
          occurence.written = true
        else
          return SimpleNode.new("*#{occurence.referenced}")
        end
      end
      ref = occurence.referenced
      if(object.respond_to? :to_sof_node) #mainly meant for arrays and hashes
        object.to_sof_node(self , level , ref )
      else
        object_sof_node(object , level , ref )
      end
    end

    # create an object node from the object
    # simple nodes are returned for small objects
    #   small means only simple attributes and only 30 chars of them
    # object nodes are basically arrays (see there)
    def object_sof_node( object , level , ref)
      if( object.is_a? Class )
        return SimpleNode.new( object.name , ref )
      end
      head = object.class.name + "("
      atts = {}
      attributes_for(object).each() do |a|
        val = get_value(object , a)
        next if val.nil?
        atts[a] =  to_sof_node(val , level + 1)
      end
      immediate , extended = atts.partition {|a,val| val.is_a?(SimpleNode) }
      head += immediate.collect {|a,val| "#{a.to_sof()} => #{val.as_string(level)}"}.join(", ") + ")"
      return SimpleNode.new(head) if( ref.nil? and extended.empty? and head.length < 30 )
      node = ObjectNode.new(head , ref)
      extended.each do |a , val|
        node.add( to_sof_node(a,level + 1) , val )
      end
      node
    end
  end
end

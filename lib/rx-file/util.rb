module RxFile

  # module for a couple of helpers that are needed in Members and Writer

  module Util
    # "value" is a property meaning simple/ not further structure
    # hence int/bool/string etc are values
    def is_value? o
      return true if [true , false ,  nil].include?(o)
      return true if [Fixnum, Symbol, String, Class].include?(o.class)
      if o.respond_to? :is_value?
        return true if o.is_value?
      end
      return false
    end

    # extract an attribute by the given name from the object
    # done with instance_variable_get
    def get_value(object,name)
      object.instance_variable_get "@#{name}".to_sym
    end

    # return a list of attributes for a given object
    # attributes may be supressed with Volotile
    # TODO should be able to specify order too
    def attributes_for object
      RxFile::Util.attributes(object)
    end

    # return a list of attributes for a given object
    # attributes may be supressed with Volotile
    # TODO should be able to specify order too
    def self.attributes( object )
      atts = object.instance_variables.collect{|i| i.to_s[1..-1].to_sym } # chop of @
      atts - Volotile.attributes(object.class)
    end
  end
end

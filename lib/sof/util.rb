module Sof
  module Util
    def is_value? o
      return true if [true , false ,  nil].include?(o)
      return true if [Fixnum, Symbol, String].include?(o.class)
      if o.respond_to? :is_value?
        return true if o.is_value?
      end
      return false
    end

    def get_value(object,name)
      object.instance_variable_get "@#{name}".to_sym
    end

    def attributes_for object
      Sof::Util.attributes(object)
    end
    def self.attributes( object )
      atts = object.instance_variables.collect{|i| i.to_s[1..-1].to_sym } # chop of @
      atts - Volotile.attributes(object.class)
    end
  end
end

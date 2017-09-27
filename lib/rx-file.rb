# Most of the external functionality is in the writer

# if you want some attributes not written also check volotile

require_relative "rx-file/util"
require_relative "rx-file/node"
require_relative "rx-file/simple_node"
require_relative "rx-file/object_node"
require_relative "rx-file/members"
require_relative "rx-file/volotile"
require_relative "rx-file/writer"
require_relative "rx-file/array_node"
require_relative "rx-file/hash_node"
require_relative "rx-file/occurence"

Object.class_eval do
  def to_rxf
    RxFile.write(self)
  end
end
Class.class_eval do
  def to_rxf
    self.name
  end
end
Symbol.class_eval do
  def to_rxf()
    ":#{to_s}"
  end
end
TrueClass.class_eval do
  def to_rxf()
    "true"
  end
end
NilClass.class_eval do
  def to_rxf()
    "nil"
  end
end
FalseClass.class_eval do
  def to_rxf()
    "false"
  end
end
String.class_eval do
  def to_rxf()
    "'" + self + "'"
  end
end
Fixnum.class_eval do
  def to_rxf()
    to_s
  end
end

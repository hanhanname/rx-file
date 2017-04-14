# Most of the external functionality is in the writer

# if you want some attributes not written also check volotile

require_relative "sof/util"
require_relative "sof/node"
require_relative "sof/simple_node"
require_relative "sof/object_node"
require_relative "sof/members"
require_relative "sof/volotile"
require_relative "sof/writer"
require_relative "sof/array_node"
require_relative "sof/hash_node"
require_relative "sof/occurence"

Class.class_eval do
  def to_sof
    self.name
  end
end
Symbol.class_eval do
  def to_sof()
    ":#{to_s}"
  end
end
TrueClass.class_eval do
  def to_sof()
    "true"
  end
end
NilClass.class_eval do
  def to_sof()
    "nil"
  end
end
FalseClass.class_eval do
  def to_sof()
    "false"
  end
end
String.class_eval do
  def to_sof()
    "'" + self + "'"
  end
end
Fixnum.class_eval do
  def to_sof()
    to_s
  end
end

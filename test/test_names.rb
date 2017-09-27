require_relative "helper"
class NamedRef < ObjectWithAttributes
  def initialize name
    super()
    @name = name
  end
  def rxf_reference_name
    @name.to_s
  end
end

class NamedTest < MiniTest::Test
  include Checker

  def test_object_one
    object = NamedRef.new("one")
    object.extra = [object]
    @out = [ {:one => object} , object ]
    check "- {:one => ->one}\n- &one NamedRef(:name => 'one', :number => 1234, :extra => [->one])"
  end
  def test_object_two
    object = NamedRef.new("one")
    object2 = NamedRef.new("two")
    object.extra = [object2]
    @out = [ {:one => object} , object2 ]
    check "- - :one => NamedRef(:name => 'one', :number => 1234, :extra => [->two])\n- &two NamedRef(:name => 'two', :number => 1234)"
  end

end

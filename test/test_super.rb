require_relative "helper"

class ASuper < Array
  def initialize object
    @object = object
  end
  attr_accessor :object
end
class HSuper < Hash
  def initialize object
    @object = object
  end
  attr_accessor :object
end
class TestSuper < MiniTest::Test
  include Checker

  def test_asuper_empty
    @out = ASuper.new( [] )
    check "ASuper(:object => [])[]"
  end
  def test_asuper_with_array
    @out = ASuper.new( [1,2,3] )
    check "ASuper(:object => [1, 2, 3])[]"
  end
  def test_asuper_as_array
    @out = ASuper.new( nil )
    @out << 1 << 2 << 3
    check "ASuper()[1, 2, 3]"
  end
  def test_asuper_as_big_array
    @out = ASuper.new( nil )
    @out << 1 << 2 << 3 << 4 << 5 << 6 << 7 << 8
    check "ASuper() - 1\n- 2\n- 3\n- 4\n- 5\n- 6\n- 7\n- 8"
  end
  def test_asuper_self_ref
    @out = ASuper.new( self )
    @out.object = @out
    check "&1 ASuper(:object => ->1) "
  end
  def test_asuper_indirect_ref
    object = ObjectWithAttributes.new
    @out = ASuper.new( object )
    object.extra = @out
    @out << 1 << 2
    check "&1 ASuper()\n :object ObjectWithAttributes(:name => 'some name', :number => 1234, :extra => ->1) - 1\n- 2"
  end

  def test_hsuper_empty
    @out = HSuper.new( {} )
    check "HSuper(:object => {}){}"
  end

end

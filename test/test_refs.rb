require_relative "helper"

class TestRefs < MiniTest::Test
  include Checker

  def setup
    @hash = {}
    @array =[]
  end
  def fill_some
    @hash[:some] = @array
    @array[1] = :one
  end

  def test_one_empty
    @out = @array << @hash
    check "-{}"
  end
  def test_two_empty
    @out = @array << @hash
    @out << @hash
    check "-&1 {}
-*1"
  end
  def test_bigger
    @out = [ { :one => @array , :two => [{ :three => @array}] } ]
    check "--:one => &1 []\n -:two => -{:three => *1}"
  end
  def test_object
    object = ObjectWithAttributes.new
    object.extra = [object]
    @out = [ {:one => object} , object ]
    check "-{:one => *1}\n-&1 ObjectWithAttributes(:name => 'some name', :number => 1234)\n  :extra [*1]"
  end
end

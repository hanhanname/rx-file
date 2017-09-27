require_relative "helper"

class ObjectRxFile < MiniTest::Test
  include Checker

  def test_simple_object
    @out = ObjectWithAttributes.new
    check "#{OBJECT_STRING}"
  end
  def test_object_extra_array
    object = ObjectWithAttributes.new
    object.extra = [:sym , 123]
    @out = object
    check "ObjectWithAttributes(:name => 'some name', :number => 1234, :extra => [:sym, 123])"
  end
  def test_array_object
    @out = [true, 1234 , ObjectWithAttributes.new]
    check "- true\n- 1234\n- #{OBJECT_STRING}"
  end
  def test_array_array_object
    @out = [true, 1 , [true , 12 , ObjectWithAttributes.new]]
    check "- true\n- 1\n- - true\n - 12\n - #{OBJECT_STRING}"
  end
  def test_hash_object
    @out = { :one => 1 , :two => ObjectWithAttributes.new }
    check "- :one => 1\n- :two => #{OBJECT_STRING}"
  end
  def test_hash_array
    @out = { :one => [1 , ObjectWithAttributes.new] , :two => true }
    check "- :one => - 1\n - #{OBJECT_STRING}\n- :two => true"
  end
  def test_object_recursive
    object = ObjectWithAttributes.new
    object.extra = object
    @out = object
    check "&1 ObjectWithAttributes(:name => 'some name', :number => 1234, :extra => ->1)"
  end
  def test_object_inline
    object = ObjectWithAttributes.new
    object.extra = Object.new
    @out = object
    check "ObjectWithAttributes(:name => 'some name', :number => 1234, :extra => Object())"
  end
  def test_volotile
    @out = ObjectWithAttributes.new
    @out.volotile = 42
    check "#{OBJECT_STRING}"
  end
  def test_class
    @out = ObjectWithAttributes
    check "ObjectWithAttributes"
  end
  def test_class_ref
    object = ObjectWithAttributes.new
    object.extra = ObjectWithAttributes
    ar = [object , ObjectWithAttributes]
    @out = ar
    check "- ObjectWithAttributes(:name => 'some name', :number => 1234, :extra => ObjectWithAttributes)\n- ObjectWithAttributes"
  end
end

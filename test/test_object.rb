class ObjectWithAttributes
  def initialize
    @name = "some name"
    @number = 1234
  end
  attr_accessor :extra
end
OBJECT_STRING = "ObjectWithAttributes(:name => 'some name', :number => 1234)"

class ObjectSof < MiniTest::Test
  include Checker

  def test_simple_object
    @out = Sof::Writer.write(ObjectWithAttributes.new)
    check "#{OBJECT_STRING}"
  end
  def test_object_extra_array
    object = ObjectWithAttributes.new
    object.extra = [:sym , 123]
    @out = Sof::Writer.write(object)
    check "#{OBJECT_STRING}\n :extra [:sym, 123]"
  end
  def test_array_object
    @out = Sof::Writer.write([true, 1234 , ObjectWithAttributes.new])
    check "-true\n-1234\n-#{OBJECT_STRING}"
  end
  def test_array_array_object
    @out = Sof::Writer.write([true, 1 , [true , 12 , ObjectWithAttributes.new]])
    check "-true\n-1\n--true\n -12\n -#{OBJECT_STRING}"
  end
  def test_hash_object
    @out = Sof::Writer.write({ one: 1 , two: ObjectWithAttributes.new })
    check "-:one => 1\n-:two => #{OBJECT_STRING}"
  end
  def test_hash_array
    @out = Sof::Writer.write({ one: [1 , ObjectWithAttributes.new] , two: true })
    check "-:one => -1\n -#{OBJECT_STRING}\n-:two => true"
  end
  def test_object_recursive
    object = ObjectWithAttributes.new
    object.extra = object
    @out = Sof::Writer.write(object)
    check "&1 ObjectWithAttributes(:name => 'some name', :number => 1234, :extra => *1)"
  end
  def test_object_inline
    object = ObjectWithAttributes.new
    object.extra = Object.new
    @out = Sof::Writer.write(object)
    check "ObjectWithAttributes(:name => 'some name', :number => 1234, :extra => Object())"
  end
  def test_class
    @out = Sof::Writer.write(ObjectWithAttributes)
    check "ObjectWithAttributes"
  end
  def test_class_ref
    object = ObjectWithAttributes.new
    object.extra = ObjectWithAttributes
    ar = [object , ObjectWithAttributes]
    @out = Sof::Writer.write(ar)
    check "-ObjectWithAttributes(:name => 'some name', :number => 1234, :extra => *1)\n-&1 ObjectWithAttributes"
  end
end

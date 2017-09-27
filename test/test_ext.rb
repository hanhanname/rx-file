require_relative "helper"

class FailValue
  def initialize str
    @name = str
  end
  def is_value?
    true
  end
end
class BasicValue < FailValue
  def to_rxf
    "'#{@name}'"
  end
end

class ObjectRxFile < MiniTest::Test
  include Checker

  def test_to_rxf
    assert_raises NoMethodError do
      RxFile::Writer.write(FailValue.new("name"))
    end
  end

  def test_basic
    @out = BasicValue.new("name")
    check "'name'"
  end

end

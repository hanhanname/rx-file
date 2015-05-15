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
  def to_sof
    "'#{@name}'"
  end
end

class ObjectSof < MiniTest::Test
  include Checker

  def test_to_sof
    assert_raises NoMethodError do
      Sof::Writer.write(FailValue.new("name"))
    end
  end

  def test_basic
    @out = BasicValue.new("name")
    check "'name'"
  end

end

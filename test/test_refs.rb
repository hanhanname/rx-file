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
end

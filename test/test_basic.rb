require_relative "helper"

class BasicSof < MiniTest::Test
  include Checker

  def test_true
    @out = true
    check "true"
  end
  def test_string
    @out = "true"
    check "'true'"
  end
  def test_num
    @out = 124
    check  "124"
  end
  def test_simple_array
    @out = [true, 1234]
    check "[true, 1234]"
  end
  def test_array_array
    @out = [true, 1 , [true , 12 ]]
    check "-true\n-1\n-[true, 12]"
  end
  def test_array_array_reverse
    @out = [ [true , 12 ], true, 1]
    check "-[true, 12]\n-true\n-1"
  end
  def test_array_array_array
    @out = [true, 1 , [true , 12 , [true , 123 ]]]
    check "-true\n-1\n--true\n -12\n -[true, 123]"
  end
  def test_simple_hash
    @out = { one: 1 , tru: true }
    check "{:one => 1, :tru => true}"
  end
  def test_array_hash
    @out = [true, 1 , { one: 1 , tru: true }]
    check "-true\n-1\n-{:one => 1, :tru => true}"
  end
  def test_array_recursive
    ar = [true, 1 ]
    ar << ar
    @out = ar
    check "&1 [true, 1, *1]"
  end
end

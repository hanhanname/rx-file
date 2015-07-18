require "rubygems"
if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "minitest/autorun"
require 'salama-object-file'

module Checker
  def check should
    out = Sof.write(@out)
    same = (should == out)
    puts "Shouldda\n#{out}" unless same
    assert_equal should , out
  end
end

class ObjectWithAttributes
  def initialize
    @name = "some name"
    @number = 1234
  end
  attr_accessor :extra , :volotile
end
OBJECT_STRING = "ObjectWithAttributes(:name => 'some name', :number => 1234)"
Sof::Volotile.add(ObjectWithAttributes , [:volotile])

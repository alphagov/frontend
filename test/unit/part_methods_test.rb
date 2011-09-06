require 'test_helper'
require "part_methods"

class PartMethodsTest < ActiveSupport::TestCase

  def setup

    @partobj = OpenStruct.new(:parts => [
        OpenStruct.new(:slug=>"a",:name=>"THISISA"),
        OpenStruct.new(:slug=>"b",:name=>"THISISB"),
        OpenStruct.new(:slug=>"c",:name=>"THISISC")
    ])
    @partobj.extend(PartMethods)
  end

  test "Should give part index by slug" do
    assert_equal 1, @partobj.part_index("b")
  end

  test "Should find part by slug" do
    assert_equal "THISISC", @partobj.find_part("c").name
  end

  test "Should give next part" do
    p = @partobj.find_part("a")
    assert_equal "THISISB", @partobj.part_after(p).name
  end

  test "Should know if at end of parts" do
    a = @partobj.find_part("a")
    b = @partobj.find_part("b")
    c = @partobj.find_part("c")
    assert @partobj.has_next_part?(a)
    assert @partobj.has_next_part?(b)
    assert !@partobj.has_next_part?(c)
  end
  
  test "Should know if at beginning of parts" do
    a = @partobj.find_part("a")
    b = @partobj.find_part("b")
    c = @partobj.find_part("c")
    assert !@partobj.has_previous_part?(a)
    assert @partobj.has_previous_part?(b)
    assert @partobj.has_previous_part?(c)
  end
end

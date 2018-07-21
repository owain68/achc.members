require 'test/unit'
require 'date'

require_relative '../year_group'

class YearGroupTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_handles_no_dob
    assert_equal 'no dob', YearGroup.on(Date.today, nil)
  end

  def test_various_dates_september_first_2018
    assert_equal 'Y4', YearGroup.on(Date.new(2018, 9, 1), '2009-12-30'), 'Sara'
    assert_equal 'Y9', YearGroup.on(Date.new(2018, 9, 1), '2005-08-24'), 'Oliver'
  end
end
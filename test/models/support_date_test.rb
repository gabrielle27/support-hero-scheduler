require 'test_helper'

class SupportDateTest < ActiveSupport::TestCase

  test "should identify weekends as non workdays" do
    assert_not SupportDate.new(next_weekend_day).is_workday?
  end

  test "should identify holidays as non workdays" do
    holiday = Holiday.create(support_date: next_non_weekend_day,
                             :name => "Jim Henson Day")
    assert_not SupportDate.new(holiday.support_date).is_workday?
  end

end



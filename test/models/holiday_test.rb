require 'test_helper'

class HolidayTest < ActiveSupport::TestCase

  #### Validations #############################################################

  test "should not create a holiday with an invalid date" do
    holiday = Holiday.create( :name => "Gelfling Day",
                              :support_date => "baddate")
    assert holiday.errors[:support_date].include? "is not a date"
  end

  test "should not create a non unique holiday" do
    holiday = Holiday.create(:name => "Jim Henson Day",
                          support_date: holidays(:one).support_date)
    assert holiday.errors[:support_date].include? "has already been taken"
  end

  test "should not create a holiday with a name that is too long" do
    holiday = Holiday.create(name: over_max_limit_string)
    assert holiday.errors[:name].include? "is too long (maximum is 255 " +
                                          "characters)"
  end

end

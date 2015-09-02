ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  INVALID_ID = -1

  def next_non_weekend_day
    date = Date.today
    date = date.advance(days: 1) while is_weekend_day?(date)
    date
  end

  def next_weekend_day
    date = Date.today
    date = date.advance(days: 1) while !is_weekend_day?(date)
    date
  end

  def is_weekend_day?(date)
    date.saturday? || date.sunday?
  end

  def over_max_limit_string
   "a" * 256
  end

  def scheduled_dates(employee)
    Schedule.where(employee_id: employee ).pluck(:support_date)
  end

  def json_value(response, key, i=0)
    resp = JSON.parse(response.body)
    resp = resp[i] if resp.is_a?(Array)
    resp.fetch(key)
  end

  def sign_in_user(employee)
    session[::CurrentUser::USER_SESSION_KEY] = employee.id
  end

end

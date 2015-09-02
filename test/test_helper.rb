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

end

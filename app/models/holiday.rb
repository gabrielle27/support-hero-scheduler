class Holiday < ActiveRecord::Base

  validates :support_date, date: true
  validates_uniqueness_of :support_date
  validates_length_of :name, maximum: 255

end

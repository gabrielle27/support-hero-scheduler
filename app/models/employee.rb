class Employee < ActiveRecord::Base

  has_many :schedules, dependent: :destroy
  has_many :conflicts, dependent: :destroy

  has_many :outgoing_swap_requests, through: :schedules
  has_many :incoming_swap_requests, through: :schedules

  validates :name, presence: true
  validates_length_of :name, maximum: 255
  validates_uniqueness_of :name

end

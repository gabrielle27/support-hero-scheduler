class Schedule < ActiveRecord::Base

  include DateValidations

  belongs_to :employee
  has_many :outgoing_swap_requests, foreign_key: :source_id,
                                  class_name: SwapRequest, dependent: :destroy
  has_many :incoming_swap_requests, foreign_key: :target_id,
                                  class_name: SwapRequest, dependent: :destroy

  validates_presence_of :employee

  validates :support_date, date: true
  validates_uniqueness_of :support_date
  validate :support_date_is_workday
  validate :employee_available

end

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

  def self.from_list(employee_list)
    employee_list.each do |employee_name|
      employee = Employee.find_or_create_by(name: employee_name)
      schedule = self.create( employee: employee,
                              support_date: SupportDate.next_open_day)
      puts schedule.errors.full_messages
    end
  end

end

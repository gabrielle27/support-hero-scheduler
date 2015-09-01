class Schedule < ActiveRecord::Base

  include DateValidations
  require 'amb'

  scope :current, -> { where("support_date >= ?", Date.today) }

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

  def self.reschedule(conflict)
    current_schedule = self.current.includes(:employee).all

    new_schedule = self.generate_new_schedule(conflict, current_schedule)

    # retry in reverse order in case conflict is last date
    if new_schedule.empty?
      new_schedule = self.generate_new_schedule(conflict,
        current_schedule.reverse)
    end

    self.replace_schedule(current_schedule, new_schedule) if new_schedule.any?
  end

  private

  def self.generate_new_schedule(conflict, current_schedule)
    schedules = {}
    begin
      current_schedule.map(&:employee).each do |e|
        date = Amb.choose( *current_schedule.map(&:support_date) )
        Amb.assert( !e.conflicts.where(support_date: date ).exists? )
        Amb.assert( !( conflict.support_date == date &&
                       conflict.employee_id == e.id ) )
        Amb.assert !schedules.has_key?(date)
        schedules[date] = Schedule.new(employee: e, support_date: date)
      end
    rescue Exception => e
      schedules = {}
    end

    schedules.values
  end

  def self.replace_schedule(current_schedule, new_schedule)
    Schedule.transaction do
      current_schedule.destroy_all
      new_schedule.each(&:save!)
    end
    true
  rescue Exception => e
    false
  end

end

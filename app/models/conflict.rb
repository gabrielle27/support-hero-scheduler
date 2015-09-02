class Conflict < ActiveRecord::Base

  include DateValidations

  belongs_to :employee

  validates_presence_of :employee

  validates :support_date, date: true
  validates_uniqueness_of :employee_id

  validate :scheduled_on_day, on: :create, unless: :accomodated

  def scheduled_on_day
    unless Schedule.where(employee: employee,
                          support_date: support_date).exists?
      self.errors[:base] << "Employee is not scheduled to work on this date"
    end
  end

end

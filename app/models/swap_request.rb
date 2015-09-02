class SwapRequest < ActiveRecord::Base

  belongs_to :source, class_name: Schedule
  belongs_to :target, class_name: Schedule

  validates_presence_of :source
  validates_presence_of :target

  validate :unique_employee
  validates_uniqueness_of :source, scope: :target

  private

  def unique_employee
    if( source && target && source.employee_id == target.employee_id )
      self.errors[:base] << "Employee may not swap days with themselves"
    end
  end

end

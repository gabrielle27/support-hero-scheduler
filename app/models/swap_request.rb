class SwapRequest < ActiveRecord::Base

  belongs_to :source, class_name: Schedule
  belongs_to :target, class_name: Schedule

  validates_presence_of :source
  validates_presence_of :target

  validate :unique_employee
  validates_uniqueness_of :source, scope: :target

  def fulfill
    begin
      success = true
      SwapRequest.transaction do
        src_copy = source.dup
        target_copy = target.dup
        source.destroy
        target.destroy
        src_copy.employee_id = target.employee_id
        target_copy.employee_id = source.employee_id
        src_copy.save!
        target_copy.save!
        self.destroy
      end
    rescue Exception => e
      puts e.message
      success = false
    end
    success
  end

  private

  def unique_employee
    if( source && target && source.employee_id == target.employee_id )
      self.errors[:base] << "Employee may not swap days with themselves"
    end
  end

end

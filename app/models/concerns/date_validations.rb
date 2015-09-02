module DateValidations

  extend ActiveSupport::Concern

  def support_date_is_workday
    unless SupportDate.new(self.support_date).is_workday?
      self.errors[:support_date] << "is not a workday"
    end
  end

  def employee_available
    if Conflict.where( employee_id: self.employee_id,
                    support_date: self.support_date).exists?
      self.errors[:employee] << "is not available on this date"
    end
  end

end

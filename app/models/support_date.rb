class SupportDate

  def initialize(date)
    @support_date = Date.parse(date.to_s) rescue nil
  end

  def is_workday?
    !is_weekend? && !is_holiday?
  end

  private

  def is_holiday?
    Holiday.where(support_date: @support_date).exists?
  end

  def is_weekend?
    @support_date.try(:saturday?) || @support_date.try(:sunday?)
  end

end

class SupportDate

  def initialize(date)
    @support_date = Date.parse(date.to_s) rescue nil
  end

  def is_workday?
    !is_weekend? && !is_holiday?
  end

  def self.next_open_day
    date = Date.today
    while( !SupportDate.new(date).is_workday? ||
          Schedule.where(support_date: date).exists? )
      date = date.advance(days: 1)
    end
    date
  end

  private

  def is_holiday?
    Holiday.where(support_date: @support_date).exists?
  end

  def is_weekend?
    @support_date.try(:saturday?) || @support_date.try(:sunday?)
  end

end

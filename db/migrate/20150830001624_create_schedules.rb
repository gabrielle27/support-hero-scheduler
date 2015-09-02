class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :employee, index: true
      t.date "support_date"
    end
  end
end

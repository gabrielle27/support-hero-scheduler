class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string "name"
      t.date "support_date"
    end
  end
end

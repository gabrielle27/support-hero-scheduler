class CreateConflicts < ActiveRecord::Migration
  def change
    create_table :conflicts do |t|
      t.references :employee, index: true
      t.date "support_date"
    end
  end
end

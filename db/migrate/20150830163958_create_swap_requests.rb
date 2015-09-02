class CreateSwapRequests < ActiveRecord::Migration
  def change
    create_table :swap_requests do |t|
      t.references :source, references: :schedule, index: true
      t.references :target, references: :schedule, index: true
    end
  end
end

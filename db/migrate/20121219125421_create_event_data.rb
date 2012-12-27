class CreateEventData < ActiveRecord::Migration
  def change
    create_table :event_data do |t|
      t.integer :event_id

      t.date :date
    end

    add_index :event_data, [:event_id, :date]

  end
end

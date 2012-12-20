class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id

      t.string :title
      
      t.datetime :start_at
      t.datetime :end_at

      t.string :recurring_type, default: "once"

      t.timestamps
    end

    add_index :events, :user_id

  end

end

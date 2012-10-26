class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
    
    add_index :email, unique: true

    add_column :password_digest, :string

    add_column :remember_token, :string
    add_index  :remember_token

    add_column :admin, :boolean, default: false
  end
end

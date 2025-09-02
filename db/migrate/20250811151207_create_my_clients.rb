class CreateMyClients < ActiveRecord::Migration[8.0]
  def change
    create_table :my_clients, id: false do |t|
      t.string :uuid, null: false, primary_key: true
      t.string :name
      t.string :email
      t.string :country
      t.string :phone
      t.integer :age

      t.timestamps
    end
  end
end

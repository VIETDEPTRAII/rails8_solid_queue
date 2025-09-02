class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :country, null: false
      t.string :street, null: false
      t.string :city, null: false
      t.string :uuid, null: false

      t.timestamps
    end

    add_foreign_key :addresses, :my_clients, column: :uuid, primary_key: :uuid
  end
end

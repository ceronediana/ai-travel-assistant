class CreateTripItems < ActiveRecord::Migration[8.1]
  def change
    create_table :trip_items do |t|
      t.string :name
      t.text :notes
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end

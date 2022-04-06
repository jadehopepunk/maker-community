class CreateEventPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :event_prices do |t|
      t.belongs_to :event
      t.string :type, default: 'Prices::Full'
      t.decimal :per_person, precision: 10, scale: 2
      t.timestamps
    end
  end
end

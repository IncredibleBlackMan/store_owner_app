class CreateSubtypeOptionPricings < ActiveRecord::Migration[6.0]
  def change
    create_table :subtype_option_pricings do |t|
      t.integer :subtype_options, array: true
      t.integer :quantity
      t.decimal :price, precision: 15, scale: 2
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateSubtypes < ActiveRecord::Migration[6.0]
  def change
    create_table :subtypes do |t|
      t.string :name
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end

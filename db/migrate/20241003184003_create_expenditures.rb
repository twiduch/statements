class CreateExpenditures < ActiveRecord::Migration[7.2]
  def change
    create_table :expenditures do |t|
      t.references :ie_statement, null: false, foreign_key: true
      t.string :category
      t.integer :amount

      t.timestamps
    end
  end
end

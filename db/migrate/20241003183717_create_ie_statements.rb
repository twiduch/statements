class CreateIeStatements < ActiveRecord::Migration[7.2]
  def change
    create_table :ie_statements do |t|
      t.string :name
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end

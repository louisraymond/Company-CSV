class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :city
      t.string :registry_number

      t.timestamps
    end

    add_index :companies, :registry_number, unique: true
  end
end
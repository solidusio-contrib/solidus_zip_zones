class CreateSpreeZipCodes < SolidusSupport::Migration[4.2]
  def change
    create_table :spree_zip_codes do |t|
      t.integer :state_id
      t.string :name

      t.timestamps
    end
  end
end

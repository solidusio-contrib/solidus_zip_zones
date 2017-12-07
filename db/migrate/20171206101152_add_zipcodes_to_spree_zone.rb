class AddZipcodesToSpreeZone < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_zones, :zipcodes, :text
  end
end

class RemoveZipcodesToSpreeZone < SolidusSupport::Migration[4.2]
  def change
    remove_column :spree_zones, :zipcodes, :text
  end
end

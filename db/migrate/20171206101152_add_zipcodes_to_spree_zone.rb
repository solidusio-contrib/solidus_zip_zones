class AddZipcodesToSpreeZone < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_zones, :zipcodes, :text
  end
end

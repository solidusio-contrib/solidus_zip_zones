module SolidusZipZones
  module ZoneDecorator
    def self.prepended(base)
      base.serialize :zipcodes, Array
    end

    Spree::Zone.prepend self
  end
end

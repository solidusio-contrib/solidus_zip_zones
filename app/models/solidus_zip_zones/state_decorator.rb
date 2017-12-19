module SolidusZipZones
  module StateDecorator
    def self.prepended(base)
      base.has_many :zip_codes
    end

    Spree::State.prepend self
  end
end

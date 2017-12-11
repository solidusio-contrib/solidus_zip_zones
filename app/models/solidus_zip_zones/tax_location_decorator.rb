module SolidusZipZones
  module TaxLocationDecorator
    def self.prepended(base)
      base.send(:attr_reader, :zipcode)
    end

    def initialize(country: nil, state: nil, zipcode: nil)
      super(country: country, state: state)

      @zipcode = zipcode
    end

    def ==(other)
      super && zipcode == other.zipcode
    end

    def empty?
      super && zipcode.blank?
    end

    Spree::Tax::TaxLocation.prepend self
  end
end

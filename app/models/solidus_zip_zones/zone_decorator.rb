module SolidusZipZones
  module ZoneDecorator
    def self.prepended(base)
      base.scope :with_member_ids, ->(state_ids, country_ids, zipcode) do
        if !state_ids.present? && !country_ids.present? && !zipcode.present?
          none
        else
          spree_zone_members_table = Spree::ZoneMember.arel_table
          matching_state =
            spree_zone_members_table[:zoneable_type].eq("Spree::State").
            and(spree_zone_members_table[:zoneable_id].in(state_ids))
          matching_country =
            spree_zone_members_table[:zoneable_type].eq("Spree::Country").
            and(spree_zone_members_table[:zoneable_id].in(country_ids))
          spree_zones_table = Spree::Zone.arel_table
          matching_zipcode = spree_zones_table[:zipcodes].matches("%#{zipcode}%")
          left_joins(:zone_members).where(matching_zipcode.or(matching_state.or(matching_country))).distinct
        end
      end

      base.scope :for_address, ->(address) do
        if address
          with_member_ids(address.state_id, address.country_id, address.zipcode)
        else
          none
        end
      end

      if SolidusSupport.solidus_gem_version < Gem::Version.new('2.4')
        class << base
          prepend ClassMethodMatch
        end
      end
    end

    module ClassMethodMatch
      def match(address)
        Spree::Deprecation.warn("Spree::Zone.match is deprecated. Please use Spree::Zone.for_address instead.", caller)

        return unless address && (matches =
                                    with_member_ids(address.state_id, address.country_id, address.zipcode).
                                    order(:zone_members_count, :created_at, :id).
                                    references(:zones))

        ['zip', 'state', 'country'].each do |zone_kind|
          if match = matches.detect { |zone| zone_kind == zone.kind }
            return match
          end
        end
        matches.first
      end
    end

    def kind
      return 'zip' if zipcodes.present?

      super
    end

    Spree::Zone.prepend self
  end
end

module SolidusZipZones
  module ZoneDecorator
    def self.prepended(base)
      base.with_options through: :zone_members, source: :zoneable do
        has_many :countries, source_type: "Spree::Country"
        has_many :states, source_type: "Spree::State"
        has_many :zip_codes, source_type: "Spree::ZipCode"
      end

      base.scope :with_member_ids, ->(state_ids, country_ids, zipcode_ids) do
        if !state_ids.present? && !country_ids.present? && !zipcode_ids.present?
          none
        else
          spree_zone_members_table = Spree::ZoneMember.arel_table
          matching_state =
            spree_zone_members_table[:zoneable_type].eq("Spree::State").
            and(spree_zone_members_table[:zoneable_id].in(state_ids))
          matching_country =
            spree_zone_members_table[:zoneable_type].eq("Spree::Country").
            and(spree_zone_members_table[:zoneable_id].in(country_ids))
          matching_zip_code =
            spree_zone_members_table[:zoneable_type].eq("Spree::ZipCode").
            and(spree_zone_members_table[:zoneable_id].in(zipcode_ids))

          matcher = matching_zip_code.or(matching_state.or(matching_country))
          joins(:zone_members).where(matcher).distinct
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
      def with_shared_members(zone)
        return none unless zone

        states_and_state_country_ids = zone.states.pluck(:id, :country_id).to_a
        state_ids = states_and_state_country_ids.map(&:first)
        state_country_ids = states_and_state_country_ids.map(&:second)
        country_ids = zone.countries.pluck(:id).to_a

        with_member_ids(state_ids, country_ids + state_country_ids, nil).distinct
      end

      def match(address)
        Spree::Deprecation.warn("Spree::Zone.match is deprecated. Please use Spree::Zone.for_address instead.", caller)

        for_address(address).first
      end
    end

    Spree::Zone.prepend self
  end
end

# frozen_string_literal: true

module SolidusZipZones
  module ZoneDecorator
    def self.prepended(base)
      base.scope :with_member_ids, ->(state_ids, country_ids, zipcode) do
        if state_ids.blank? && country_ids.blank? && zipcode.blank?
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
    end

    def kind
      return 'zip' if zipcodes.present?

      super
    end

    Spree::Zone.prepend self
  end
end

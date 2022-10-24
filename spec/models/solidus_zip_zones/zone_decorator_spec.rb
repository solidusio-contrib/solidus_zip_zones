require 'spec_helper'

RSpec.describe SolidusZipZones::ZoneDecorator, type: :model do
  describe 'for_address' do
    subject(:zone_for_address) { Spree::Zone.for_address(address) }

    let(:new_york_address) { create(:address, state_code: "NY", zipcode: '11203') }
    let(:alabama_address) { create(:address) }
    let(:canada_address) { create(:address, country_iso_code: "CA") }

    let!(:new_york_zone) { create(:zone, states: [new_york_address.state]) }
    let!(:alabama_zone) { create(:zone, states: [alabama_address.state]) }
    let!(:united_states_zone) { create(:zone, countries: [new_york_address.country]) }
    let!(:canada_zone) { create(:zone, countries: [canada_address.country]) }
    let!(:north_america_zone) { create(:zone, countries: [canada_address.country, new_york_address.country]) }
    let!(:nyc_zip_zone) { create(:zone, zipcodes: "11203,11204,11205,11206") }

    context 'when there is no address' do
      let(:address) { nil }

      it 'returns an empty relation' do
        expect(zone_for_address).to eq([])
      end
    end

    context 'with address in New York' do
      let(:address) { new_york_address }

      it 'matches the New York zone' do
        expect(zone_for_address).to include(new_york_zone)
      end

      it 'matches the United States zone' do
        expect(zone_for_address).to include(united_states_zone)
      end

      it 'does not match the Alabama zone' do
        expect(zone_for_address).not_to include(alabama_zone)
      end

      it 'does not match the Canadian zone' do
        expect(zone_for_address).not_to include(canada_zone)
      end

      it 'matches the North America zone' do
        expect(zone_for_address).to include(north_america_zone)
      end

      it 'matches the NYC zip zone' do
        expect(zone_for_address).to include(nyc_zip_zone)
      end
    end

    context 'with an address outside NYC zip' do
      let(:new_york_address) { create(:address, state_code: "NY", zipcode: '11202') }
      let(:address) { new_york_address }

      it 'does not match the NYC zip zone' do
        expect(zone_for_address).not_to include(nyc_zip_zone)
      end
    end

    context 'for Zip+4 in US' do
      let(:new_york_plus4_address) { create(:address, state_code: "NY", zipcode: '11203-3006') }
      let(:address) { new_york_plus4_address }

      it 'matches the United States zone' do
        expect(subject).to include(new_york_zone)
      end
    end

  end
end

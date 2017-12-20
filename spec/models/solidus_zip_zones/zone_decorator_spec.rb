require 'spec_helper'

RSpec.describe SolidusZipZones::ZoneDecorator, type: :model do
  describe 'for_address' do
    let(:new_york_address) { create(:address, state_code: "NY", zipcode: '11203') }
    let(:alabama_address)  { create(:address) }
    let(:canada_address)   { create(:address, country_iso_code: "CA") }
    let(:nyc_zip_codes) do
      [
        create(:zip_code, state_code: "NY", name: '11203'),
        create(:zip_code, state_code: "NY", name: '11204'),
        create(:zip_code, state_code: "NY", name: '11205'),
        create(:zip_code, state_code: "NY", name: '11206')
      ]
    end

    let!(:new_york_zone) { create(:zone, states: [new_york_address.state]) }
    let!(:alabama_zone) { create(:zone, states: [alabama_address.state]) }
    let!(:united_states_zone) { create(:zone, countries: [new_york_address.country]) }
    let!(:canada_zone) { create(:zone, countries: [canada_address.country]) }
    let!(:north_america_zone) { create(:zone, countries: [canada_address.country, new_york_address.country]) }
    let!(:nyc_zip_zone) { create(:zone, zip_codes: nyc_zip_codes) }
    subject { Spree::Zone.for_address(address) }

    context 'when there is no address' do
      let(:address) { nil }
      it 'returns an empty relation' do
        expect(subject).to eq([])
      end
    end

    context 'for an address in New York' do
      let(:address) { new_york_address }

      it 'matches the New York zone' do
        expect(subject).to include(new_york_zone)
      end

      it 'matches the United States zone' do
        expect(subject).to include(united_states_zone)
      end

      it 'does not match the Alabama zone' do
        expect(subject).not_to include(alabama_zone)
      end

      it 'does not match the Canadian zone' do
        expect(subject).not_to include(canada_zone)
      end

      it 'matches the North America zone' do
        expect(subject).to include(north_america_zone)
      end

      it 'matches the NYC zip zone' do
        expect(subject).to include(nyc_zip_zone)
      end
    end

    context 'for an address outside NYC zip' do
      let(:new_york_address) { create(:address, state_code: "NY", zipcode: '11202') }
      let(:address) { new_york_address }

      it 'does not match the NYC zip zone' do
        expect(subject).to_not include(nyc_zip_zone)
      end
    end
  end

  if SolidusSupport.solidus_gem_version < Gem::Version.new('2.4')
    context "#match" do
      let(:country_zone) { create(:zone, name: 'CountryZone') }
      let(:country) do
        country = create(:country)
        # Create at least one state for this country
        create(:state, country: country)
        country
      end

      before { country_zone.members.create(zoneable: country) }

      context "when there is only one qualifying zone" do
        let(:address) { create(:address, country: country, state: country.states.first) }

        it "should return the qualifying zone" do
          Spree::Deprecation.silence do
            expect(Spree::Zone.match(address)).to eq(country_zone)
          end
        end
      end

      context "when there are two qualified zones with same member type" do
        let(:address) { create(:address, country: country, state: country.states.first) }
        let(:second_zone) { create(:zone, name: 'SecondZone') }

        before { second_zone.members.create(zoneable: country) }

        context "when both zones have the same number of members" do
          it "should return the zone that was created first" do
            Spree::Deprecation.silence do
              expect(Spree::Zone.match(address)).to eq(country_zone)
            end
          end
        end

        context "when one of the zones has fewer members" do
          let(:country2) { create(:country) }

          before { country_zone.members.create(zoneable: country2) }

          it "should return the zone with fewer members" do
            Spree::Deprecation.silence do
              expect(Spree::Zone.match(address)).to eq(second_zone)
            end
          end
        end
      end

      context "when there are two qualified zones with different member types" do
        let(:state_zone) { create(:zone, name: 'StateZone') }
        let(:address) { create(:address, country: country, state: country.states.first) }

        before { state_zone.members.create(zoneable: country.states.first) }

        it "should return the zone with the more specific member type" do
          Spree::Deprecation.silence do
            expect(Spree::Zone.match(address)).to eq(state_zone)
          end
        end
      end

      context "when there are three qualified zones with different member types" do
        let!(:zip_zone)  { create(:zone, zip_codes: zip_codes) }
        let(:state_zone) { create(:zone, name: 'StateZone') }

        let(:zip_codes) do
          [
            create(:zip_code, state_code: "AL", name: '12345'),
            create(:zip_code, state_code: "AL", name: '12346')
          ]
        end

        let(:address) do
          create(:address,
                 country: country,
                 state: country.states.first,
                 zipcode: '12345')
        end

        before do
          state_zone.members.create(zoneable: country.states.first)
        end

        it "should return the zone with the more specific member type" do
          Spree::Deprecation.silence do
            expect(Spree::Zone.match(address)).to eq(zip_zone)
          end
        end
      end

      context "when there are no qualifying zones" do
        it "should return nil" do
          Spree::Deprecation.silence do
            expect(Spree::Zone.match(Spree::Address.new)).to be_nil
          end
        end
      end
    end
  end
end

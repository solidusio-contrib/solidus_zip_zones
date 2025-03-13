require 'spec_helper'

RSpec.describe SolidusZipZones::TaxLocationDecorator do
  subject(:new_tax_location) { Spree::Tax::TaxLocation.new }

  let(:country) { build_stubbed(:country) }
  let(:state) { build_stubbed(:state) }
  let(:zipcode) { '12345' }

  it { is_expected.to respond_to(:state_id) }
  it { is_expected.to respond_to(:country_id) }

  describe "default values" do
    it "has a nil state and country id" do
      expect(new_tax_location.state_id).to eq(nil)
      expect(new_tax_location.country_id).to eq(nil)
    end
  end

  describe '#==' do
    let(:other) { Spree::Tax::TaxLocation.new(state: nil, country: nil) }

    it 'compares the values of state id and country id and does not care about object identity' do
      expect(new_tax_location).to eq(other)
    end

    context "with different zip code" do
      let(:other) { Spree::Tax::TaxLocation.new(state: nil, country: nil, zipcode: '67890') }

      it "distinct by zipcode" do
        expect(new_tax_location).not_to eq(other)
      end
    end
  end

  describe "initialization" do
    subject(:new_tax_location) { Spree::Tax::TaxLocation.new(**args) }

    context 'with a country object' do
      let(:args) { { country: country } }

      it "yields a location with that country's id" do
        expect(new_tax_location.country_id).to eq(country.id)
      end
    end
  end

  describe "#country" do
    subject { Spree::Tax::TaxLocation.new(**args).country }

    let(:country) { create(:country) }

    context 'with a country object' do
      let(:args) { { country: country } }

      it { is_expected.to eq(country) }
    end

    context 'with no country object' do
      let(:args) { { country: nil } }

      it { is_expected.to be nil }
    end
  end

  describe "#empty?" do
    subject { Spree::Tax::TaxLocation.new(**args).empty? }

    context 'with a country present' do
      let(:args) { { country: country } }

      it { is_expected.to be false }
    end

    context 'with a state present' do
      let(:args) { { state: state } }

      it { is_expected.to be false }
    end

    context 'with a zip present' do
      let(:args) { { zipcode: zipcode } }

      it { is_expected.to be false }
    end

    context 'with no region data present' do
      let(:args) { {} }

      it { is_expected.to be true }
    end
  end
end

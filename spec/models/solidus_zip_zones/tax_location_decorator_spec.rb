require 'spec_helper'

RSpec.describe SolidusZipZones::TaxLocationDecorator do
  let(:country) { build_stubbed(:country) }
  let(:state) { build_stubbed(:state) }
  let(:zipcode) { '12345' }

  subject { Spree::Tax::TaxLocation.new }

  it { is_expected.to respond_to(:state_id) }
  it { is_expected.to respond_to(:country_id) }

  describe "default values" do
    it "has a nil state and country id" do
      expect(subject.state_id).to eq(nil)
      expect(subject.country_id).to eq(nil)
    end
  end

  describe '#==' do
    let(:other) { Spree::Tax::TaxLocation.new(state: nil, country: nil) }

    it 'compares the values of state id and country id and does not care about object identity' do
      expect(subject).to eq(other)
    end

    context "with different zip code" do
      let(:other) { Spree::Tax::TaxLocation.new(state: nil, country: nil, zipcode: '67890') }

      it "distinct by zipcode" do
        expect(subject).to_not eq(other)
      end
    end
  end

  describe "initialization" do
    subject { Spree::Tax::TaxLocation.new(args) }

    context 'with a country object' do
      let(:args) { { country: country } }

      it "will yield a location with that country's id" do
        expect(subject.country_id).to eq(country.id)
      end
    end
  end

  describe "#country" do
    let(:country) { create(:country) }
    subject { Spree::Tax::TaxLocation.new(args).country }

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
    subject { Spree::Tax::TaxLocation.new(args).empty? }

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

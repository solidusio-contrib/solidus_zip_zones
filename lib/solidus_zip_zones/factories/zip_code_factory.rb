require 'spree/testing_support/factories/state_factory'

FactoryBot.define do
  factory :zip_code, class: 'Spree::ZipCode' do
    transient do
      state_code 'AL'
    end

    state do
      Spree::State.find_by(abbr: state_code)
    end
  end
end

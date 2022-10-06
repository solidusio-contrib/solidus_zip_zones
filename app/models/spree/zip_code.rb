module Spree
  class ZipCode < Spree::Base
    belongs_to :state, class_name: 'Spree::State'
    has_many :addresses, dependent: :nullify

    validates :state, presence: true
    validates :name, presence: true, format: { with: /\A[0-9]{5}\z/ }
  end
end

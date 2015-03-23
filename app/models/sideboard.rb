class Sideboard < ActiveRecord::Base
  belongs_to :deck
  has_and_belongs_to_many :cards
end

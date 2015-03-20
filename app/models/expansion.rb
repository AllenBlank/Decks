class Expansion < ActiveRecord::Base
  has_many :cards
  serialize :booster
end

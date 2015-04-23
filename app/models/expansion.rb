class Expansion < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  serialize :booster
end

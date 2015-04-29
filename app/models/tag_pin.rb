class TagPin < ActiveRecord::Base
  belongs_to :tag
  
  belongs_to :deck
  belongs_to :pile
  belongs_to :synergy
end

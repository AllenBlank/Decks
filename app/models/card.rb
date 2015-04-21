class Card < ActiveRecord::Base
  
  belongs_to :expansion
  has_many :piles, dependent: :destroy
  has_many :decks, through: :piles
  
  serialize :types
  serialize :colors
  serialize :rulings
  serialize :foreign_names
  serialize :printings
  serialize :subtypes
  serialize :names
  serialize :supertypes
  serialize :variations
  serialize :color_id
  serialize :formats
  serialize :legalities
  
  def low_res_url
    image_url 'low'
  end
  
  def high_res_url
    image_url 'high'
  end
  
  private
    def image_url res
      return DEFAULT_IMAGE_URL unless self.uploaded 
      url = (res == 'high' ? AWS_HIGH_RES_URL : AWS_LOW_RES_URL )
      url + self.image_name + '.jpg'
    end
end

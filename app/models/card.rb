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
  
  def grab_image
    image_name = self.image_name + '.jpg'
    num = self.number
    set_code = self.expansion.code.downcase
    remote_url = "http://magiccards.info/scans/en/#{set_code}/#{num}.jpg"
    
    if url_works remote_url
      require 'open-uri'
      download = open(remote_url)
      
      s3 = AWS::S3.new
      s3.buckets[AWS_BUCKET_NAME].objects[ 'high_res/' + image_name ].write( download )
      
      download.delete.close
      self.update uploaded: true
    else
      false
    end
      
  end
  
  private
    def image_url res
      if self.uploaded 
        url = (res == 'high' ? AWS_HIGH_RES_URL : AWS_LOW_RES_URL )
        url + self.image_name + '.jpg'
      else
        doppleganger = Card.where(name: self.name, uploaded: true).first
        if doppleganger
          doppleganger.send(:image_url, res)
        else
          DEFAULT_IMAGE_URL
        end
      end
    end
    
    def url_works url
      uri = URI(url)
      request = Net::HTTP.new uri.host
      response= request.request_head uri.path
      return response.code.to_i == 200
    end
end

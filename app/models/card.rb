class Card < ActiveRecord::Base
  
  belongs_to :expansion
  
  serialize :types
  serialize :colors
  serialize :rulings
  serialize :foreign_names
  serialize :printings
  serialize :subtypes
  serialize :names
  serialize :supertypes
  serialize :variations
  
  def low_res_url
    image_url 'low'
  end
  
  def high_res_url
    image_url 'high'
  end
  
  private
  
    def image_url res
      unless self.uploaded
        return DEFAULT_IMAGE_URL unless self.multiverse_id
        begin
          fetch_and_push_images
          self.update uploaded: true
        rescue
          return DEFAULT_IMAGE_URL
        end
      end
      case res
        when 'high'
          url = AWS_HIGH_RES_URL
        else
          url = AWS_LOW_RES_URL
      end
      url + self.image_name + '.jpg'
    end
  
    def url_works url
      uri = URI(url)
      request = Net::HTTP.new uri.host
      response= request.request_head uri.path
      return response.code.to_i == 200
    end
    
    def fetch_and_push_images
      image_name = self.image_name + '.jpg'
      multiverse_id = self.multiverse_id.to_s
      
      require 'open-uri'
      high_res_download = open(REMOTE_HIGH_RES_URL + multiverse_id + '.jpg')
      low_res_download =  open(REMOTE_LOW_RES_URL  + multiverse_id + '.jpeg')
      
      s3 = AWS::S3.new
      s3.buckets[AWS_BUCKET_NAME].objects[ 'high_res/' + image_name ].write( high_res_download )
      s3.buckets[AWS_BUCKET_NAME].objects[ 'low_res/'  + image_name ].write( low_res_download  )
      
      high_res_download.delete.close
      low_res_download.delete.close
    end
end

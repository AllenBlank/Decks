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
  
    
  # a method that gives the cards image_url if it has one, 
  # and if it doesn't, downloads one and uploads that image to my s3 bucket.
  def serve_image_url card=self
    return card.image_url if card.image_url # return url if it exists already
    require 'open-uri' # needed to open remote files easily.
    
    # all this is pretty obvious, sloppy. mtgdb has images named by multi-verse id.
    bucket_name = 'ab-card-images'
    file_name = card.multiverseid.to_s + ".jpg"
    aws_url = "http://#{bucket_name}.s3.amazonaws.com/#{file_name}"
    remote_url = "http://api.mtgdb.info/content/hi_res_card_images/" + file_name
    default_url = "http://#{bucket_name}.s3.amazonaws.com/Back.jpg"
    
    # if there is no multi-verse id or the site doesn't have the image, set to 
    # default... the card back image.
    
    unless card.multiverseid && url_works( remote_url )
      card.update image_url: default_url
      return default_url
    else
    
    # if there is a multiverse id, and the image exists, try to fetch it and upload,
    # then delete the temp file afterwards, set the image_url property and return the path.
      begin
        download = open(remote_url)
        s3 = AWS::S3.new
        s3.buckets[bucket_name].objects[file_name].write(download)
        download.delete
        card.update image_url: aws_url
        return aws_url
      rescue
        return default_url
      end
    end
    
  end
  
  private
    def url_works url
      uri = URI(url)
      request = Net::HTTP.new uri.host
      response= request.request_head uri.path
      return response.code.to_i == 200
    end
end

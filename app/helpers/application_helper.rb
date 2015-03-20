module ApplicationHelper
  def card_image_url card
    return card.image_url if card.image_url
    require 'open-uri'
    
    amazon = S3::Service.new(access_key_id: 'KEY', secret_access_key: 'KEY')
    bucket = amazon.buckets.find('image_storage')
    url = 'http://www.example.com/url'
    download = open(url)
    
    file = bucket.objects.build('image.png')
    file.content = (File.read download)
    
  end
end

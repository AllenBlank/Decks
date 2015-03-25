AWS.config(access_key_id: ENV['AWS_CARDS_KEY'], secret_access_key: ENV['AWS_CARDS_SECRET'] )

AWS_BUCKET_NAME = 'ab-card-images'
AWS_URL = "https://#{AWS_BUCKET_NAME}.s3.amazonaws.com/"

AWS_LOW_RES_URL = AWS_URL + 'low_res/'
AWS_HIGH_RES_URL = AWS_URL + 'high_res/'
DEFAULT_IMAGE_URL = AWS_URL + 'Back.jpg'

REMOTE_HIGH_RES_URL = "http://api.mtgdb.info/content/hi_res_card_images/"
REMOTE_LOW_RES_URL = "http://api.mtgdb.info/content/card_images/"
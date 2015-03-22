Card.find_each do |card|
  image_name = card.expansion.code + card.name
  image_name = image_name.gsub(' ','').underscore
  card.update(image_name: image_name)
end
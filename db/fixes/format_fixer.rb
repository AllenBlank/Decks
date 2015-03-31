Card.where(formats: nil).each do |card|
  next if card.legalities.nil?
  string = card.legalities.gsub('=>',':')
  card.legalities = JSON.parse string
  card.formats = []
  card.legalities.each do |k,v|
    if v == "Restricted" ||  v == "Legal"
      card.formats << k
    end
  end
  card.save
end
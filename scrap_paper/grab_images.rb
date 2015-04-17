query = Card.where.not(multiverse_id: nil).where(uploaded: nil)
total = query.count
current = 0
query.find_each do |card|
  unless card.low_res_url == DEFAULT_IMAGE_URL
    current += 1
    puts "#{current} out of #{total} done."
  else
    card.update uploaded: false
  end
end
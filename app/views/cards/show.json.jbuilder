json.merge! @card.attributes

json.low_res_url  @card.low_res_url
json.high_res_url @card.high_res_url

json.partialHTML render partial: 'card.html.erb', locals: { card: @card }
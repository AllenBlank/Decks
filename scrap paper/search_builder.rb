
def parse_search search_string
  cards = card = Card.arel_table
  
end


def first_paren string
  chars = string.split ''
  start = 0
  ending = 0
  chars.each_with_index do |c,i|
    next unless c == '('
    if c == '('
      start = i
      openings = 0
      closings = 0
      (start...chars.length).each do |j|
        openings += 1 if chars[j] == '('
        closings += 1 if chars[j] == ')'
        ending = j if openings == closings
      end
      break
    end
  end
  
  ending > start ? string[start...ending] : string
end
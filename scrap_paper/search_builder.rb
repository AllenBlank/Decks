
def parse_search_arr arr, query
  operator = nil
  arr.each do |e|
    if e.kind_of?(String)
      result = parse_search_string( e, query )
      query = result[:query]
      operator = result[:operator]
    else
      operator ||= "AND"
      query = add_operand( parse_search_arr( e, query ), operator, query )
      operator = nil
    end
  end
  query
end

def parse_search_string str, query
  operators = ["AND","OR","NOT"]
  terms = str.split(' ')
  operator = nil
  result = {operator: operator, query: query}
  while terms[0] do
    term = terms.shift
    if operators.include? term
      terms[0].nil? ? result[:operator] = term : operator = term
    else
      operator ||= "AND"
      term = fix_quotes term
      result[:query] = add_operand( build_term(term), operator, result[:query] )
      operator = nil
    end
  end
  result
end

def add_operand( query_to_add, operator, query)
  anchor = Card.arel_table
  case operator
  when "AND"
    query.and( anchor.grouping( query_to_add ) )
  when "OR"
    query.or( anchor.grouping( query_to_add ) )
  when "NOT"
    query.and( anchor.grouping( query_to_add.not ) )
  end
end

def build_term term
  local_card = Card.arel_table
  local_card[:name].matches("%#{term}%")
end

def search_string_to_array str
  disallowed_regex = /\[|\]|\,/
  
  str.gsub!(disallowed_regex, '')
  str.gsub! '(', '", ["'
  str.gsub! ')', '"], "'
  str = '["' + str + '"]'
  JSON.parse str
end

def clean_arr a
    a.reject! {|e| e.blank?}
    a.each do |e|
        clean_arr e if e.kind_of?(Array)
        e.strip! if e.kind_of?(String)
    end
    a
end

def fix_quotes quoted
  quote_regex = /"(.*?)"/
  while quoted[quote_regex]
    substr = quoted[quote_regex]
    index = quoted.index(quote_regex)
    substr.gsub!('"', '$').gsub!(' ', '+')
    quoted[index ... index + substr.length ] = substr
  end
  quoted
end

def re_quote quoted
  quoted.gsub!('$', '"').gsub!('+', ' ')
end

search_string = 'nigh vamp OR (mud mix)'
search_string = fix_quotes search_string
test_array = search_string_to_array( search_string )
test_array = clean_arr( test_array )

card = Card.arel_table
pquery = card[:name].not_eq(nil)

test_query = parse_search_arr(test_array, pquery)
test_query.to_sql
Card.where(test_query).count
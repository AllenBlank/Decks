def queryfy_array query_array
  query = Card.arel_table[:name].not_eq(nil)
  table = Card.arel_table
  operators = ["AND", "OR", "NOT"]
  operator = nil
  operator_to_pass_on = nil
  while query_array[0] do
    element = query_array.shift
    
    if element.kind_of?(Array)
      results_hash = queryfy_array( element )
      query_to_add = results_hash[:query]
      operator = results_hash[:operator]
    elsif element.kind_of?(String)
      if operators.include? element
        query_array[0].nil? ? operator_to_pass_on = element : operator = element
        next
      end
      query_to_add = table[:name].matches("%#{ re_quote element }%")
    end
    
    operator ||= "AND"
    case operator
    when "AND"
      query = query.and(table.grouping( query_to_add ) )
    when "OR"
      query = query.or(table.grouping( query_to_add ) )
    when "NOT"
      query = query.and(table.grouping( query_to_add.not ) )
    end 
    operator = nil
  end
  {operator: operator_to_pass_on, query: query}
end


def search_string_to_array str
  disallowed_regex = /\[|\]|\,/
  
  str.gsub!(disallowed_regex, '')
  str.gsub! '(', '", ["'
  str.gsub! ')', '"], "'
  str = '["' + str + '"]'
  JSON.parse str
end

def clean_array a
  a.reject! {|e| e.blank?}
  a.each do |e|
    clean_array e if e.kind_of? Array
    e.strip! if e.kind_of? String 
  end
  a
end

def split_strings arr
  sol = []
  arr.each do |e|
    sol << e.split(' ') if e.kind_of?(String)
    sol << split_strings(e) if e.kind_of?(Array)
  end
  sol
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
  quoted.gsub('$', '').gsub('+', ' ')
end

def run_search str
  str = fix_quotes str
  arr = search_string_to_array str
  arr = split_strings arr
  arr = clean_array arr
  query = queryfy_array(arr)[:query]
  puts query.to_sql
  Card.where(query)
end

run_search 'vamp night NOT (mud OR mix)'
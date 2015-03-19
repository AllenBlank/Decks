require 'yajl'
require 'active_support/inflector'

card_properties = {}
set_properties = {}

Dir.foreach('./all_sets') do |file_name|
  next if file_name == '.' or file_name == '..'
  
  parser = Yajl::Parser.new
  json = File.new('./all_sets/' + file_name, 'r')
  hash = parser.parse(json)
  json.close
  
  hash.each do |k,v|
    property = k.underscore
    unless set_properties[property]
      set_properties [ property ] = {
        name: property,
        original: k,
        type: v.class.to_s,
      }
    end
    
  end
  

  hash["cards"].each do |card|
    card.each do |k,v|
      property = k.underscore
      unless card_properties[ property ]
        card_properties [ property ] = {
          name: property,
          original: k,
          type: v.class.to_s,
        }
        
      end
    end
  end
end

def gen(properties)
  class_composition = ''
  serialize_list = ''
  
  properties.each do |k,v|
    type = 'string'
    case v[:type]
      when 'Fixnum'
        type = 'integer'
      when 'TrueClass'
        type = 'boolean'
      when 'Array' || 'Hash'
        serialize_list += v[:name] +', '
    end
    class_composition += "#{v[:name]}:#{type} "
  end
  puts serialize_list
  puts class_composition
end

gen card_properties
gen set_properties
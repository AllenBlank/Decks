class Search < ActiveRecord::Base
  include SearchesHelper
  belongs_to :user
  serialize :parameters
  serialize :colors
  
  def initialize attributes={}
    super
    self.sort_by_field ||= "Name"
    self.sort_direction_field ||= "Ascending"
  end
  
  def cards
    query = Card.where(newest: true)

    query = build_basic_query query
    query = build_color_query query
    query = build_advanced_query query
    
    order_query query
  end
  
  private
  
    def build_advanced_query query
      q = QueryParser.new
      query = q.adv_query(query, self.advanced_field) unless self.advanced_field.blank?
      query
    end
    
    def build_basic_query query
      q = QueryParser.new
      basic_fields = {
        "n:" => self.name_field,
        "o:" => self.text_field,
        "t:" => self.type_field,
        "f:" => self.format_field,
      }
      
      basic_fields.each do |prefix, terms|
        query = q.adv_query_by_prefix(query, prefix, terms ) unless terms.blank?
      end
      query
    end
    
    def build_color_query query
      q = QueryParser.new
      color_parameters = {
        "White" => "w", 
        "Blue"  => "u", 
        "Black" => "b", 
        "Red"   => "r", 
        "Green" => "g"
      }
      self.exact_field ? ci_prefix = 'ci!' : ci_prefix = 'ci:'
      color_query = ''
      color_parameters.each do |color_name, color_char|
        color_query << color_char if !self.colors.nil? && self.colors.include?( color_name )
      end
      query = q.adv_query_by_prefix(query, ci_prefix, color_query) unless color_query.empty?
      query
    end
    
    def order_query query
      attribute = self.sort_by_field.downcase.to_sym
      direction = (self.sort_direction_field == "Ascending") ? :asc : :desc
      #byebug
      query.order( attribute => direction )
    end
  
end
